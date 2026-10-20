//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing
@testable import enum SwiftStructureKit.ArrayBuilder

protocol ConvertibleToData {
	func convertToData() -> Data
}

extension Data: ConvertibleToData {
	func convertToData() -> Data { self }
}

extension String: ConvertibleToData {
	func convertToData() -> Data { Data(utf8) }
}

enum ReferenceTest {
	/// Compares two in-memory values.
	///
	/// Use this when both values are large and difficult to compare in the standard test output.
	static func assert(
		_ actual: some ConvertibleToData,
		matches expected: some ConvertibleToData,
		attachmentName: String? = nil,
		sourceLocation: SourceLocation = #_sourceLocation,
	) {
		let actual = actual.convertToData()
		let expected = expected.convertToData()

		guard actual != expected else {
			return
		}

		let attachmentName = attachmentName ?? UUID().uuidString
		_recordAttachment(actual, attachmentName: "\(attachmentName)_actual.swift", sourceLocation: sourceLocation)
		_recordAttachment(expected, attachmentName: "\(attachmentName)_expected.swift", sourceLocation: sourceLocation)

		do {
			// Outputs were different, let's find out why. We're going
			// to use Git, so will need to write the results to a file.
			let actualURL = try _writeToFile(actual)
			defer { try? FileManager.default.removeItem(at: actualURL) }

			let expectedURL = try _writeToFile(expected)
			defer { try? FileManager.default.removeItem(at: expectedURL) }

			try _assert(
				actualURL,
				matches: expectedURL,
				attachmentName: attachmentName,
				sourceLocation: sourceLocation,
			)
		} catch {
			Issue.record(error, sourceLocation: sourceLocation)
		}
	}

	/// Compares a value against a reference fixture on disk.
	///
	/// The actual output is attached and named after the fixture so it can be found in test results.
	static func assert(
		_ actual: some ConvertibleToData,
		matches expectedURL: URL,
		sourceLocation: SourceLocation = #_sourceLocation,
	) {
		let actual = actual.convertToData()

		let fixtureName = expectedURL.deletingPathExtension().lastPathComponent
		_recordAttachment(actual, attachmentName: "\(fixtureName)_actual.swift", sourceLocation: sourceLocation)

		do {
			let expected = try Data(contentsOf: expectedURL)
			guard actual != expected else {
				return
			}

			// Outputs were different, let's find out why. We're going
			// to use Git, so will need to write the actual results to
			// a file.
			let actualURL = try _writeToFile(actual)
			defer { try? FileManager.default.removeItem(at: actualURL) }

			try _assert(
				actualURL,
				matches: expectedURL,
				attachmentName: fixtureName,
				sourceLocation: sourceLocation,
			)
		} catch {
			Issue.record(error, sourceLocation: sourceLocation)
		}
	}

	private static func _defaultAttachmentName(for sourceLocation: SourceLocation) -> String {
		let file = URL(filePath: sourceLocation.fileName).deletingPathExtension().lastPathComponent
		return "\(file)_\(sourceLocation.line)"
	}

	private static func _recordAttachment(
		_ data: Data,
		attachmentName: String = UUID().uuidString,
		sourceLocation: SourceLocation,
	) {
		// Make the generated output available in the test results.
		// Note to self: successful tests will delete
		//               attachments (configurable by test plans)
		Attachment.record(
			String(decoding: data, as: UTF8.self),
			named: attachmentName,
			sourceLocation: sourceLocation,
		)
	}

	private static func _writeToFile(_ data: Data) throws -> URL {
		let path = FileManager.default.temporaryDirectory
			.appending(component: UUID().uuidString)
		try data.write(to: path)
		return path
	}

	private static func _assert(
		_ actualURL: URL,
		matches expectedURL: URL,
		attachmentName: String,
		sourceLocation: SourceLocation,
	) throws {
		let diff = try _gitDiff(
			expected: expectedURL,
			actual: actualURL,
		)
		let whitespaceDiff = try _gitDiff(
			expected: expectedURL,
			actual: actualURL,
			ignoringWhitespace: true,
		)
		// If every difference disappears when whitespace is ignored, they are all
		// whitespace-only issues, so each issue line can say so.
		let isWhitespaceOnly = !whitespaceDiff.hasDifferences

		// Keep the complete git output for diffs with surrounding context
		_recordAttachment(diff.rawOutput.convertToData(), attachmentName: "\(attachmentName).diff", sourceLocation: sourceLocation)

		guard !diff.changes.isEmpty else {
			Issue.record("Generated output does not match reference.", sourceLocation: sourceLocation)
			return
		}

		// Report each diff hunk as separate issues to make it easier to grok.
		for change in diff.changes {
			Issue.record(
				"""
				\(change.summary(isWhitespaceOnly: isWhitespaceOnly))
				\(change.body)
				""",
				sourceLocation: sourceLocation
			)
		}
	}

	private static func _gitDiff(
		expected: URL,
		actual: URL,
		ignoringWhitespace: Bool = false,
	) throws -> GitResult {
		let process = Process()
		let output = Pipe()
		let error = Pipe()

		process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
		process.arguments = _gitArguments(
			ignoresWhitespace: ignoringWhitespace,
			expected: expected,
			actual: actual
		)
		process.standardOutput = output
		process.standardError = error

		try process.run()

		let data = output.fileHandleForReading.readDataToEndOfFile()
		let errorData = error.fileHandleForReading.readDataToEndOfFile()
		process.waitUntilExit()

		// Status codes from git diff
		//  0  = identical
		//  1  = differences found
		//  >1 = error
		guard process.terminationStatus <= 1 else {
			throw GitDiffError(
				terminationStatus: process.terminationStatus,
				output: String(decoding: errorData, as: UTF8.self),
			)
		}

		let diff = String(decoding: data, as: UTF8.self)
		return GitResult(
			rawOutput: diff,
			changes: _changes(in: diff),
			hasDifferences: process.terminationStatus == 1,
		)
	}

	@ArrayBuilder<String>
	private static func _gitArguments(ignoresWhitespace: Bool, expected: URL, actual: URL) -> [String] {
		"diff"
		"--no-index"
		"--no-color" // in case color.ui = always is set globally
		"--diff-algorithm=histogram"
		if ignoresWhitespace {
			"--ignore-all-space"
		}
		"--"
		expected.path
		actual.path
	}

	/// Splits git's output into one change per unbroken run of removed/added lines.
	///
	/// Git groups nearby changes into a single hunk and pads each with context lines.
	/// Line numbers are tracked here rather than read from the hunk header, so each
	/// change gets exact ranges and the context is dropped.
	private static func _changes(in diff: String) -> [Change] {
		var changes: [Change] = []
		var current: Change?
		var expectedLine = 0
		var actualLine = 0
		var inHunk = false

		func finishCurrent() {
			if let change = current {
				changes.append(change)
				current = nil
			}
		}

		for line in diff.split(separator: "\n", omittingEmptySubsequences: true) {
			if line.hasPrefix("@@") {
				finishCurrent()
				guard let starts = _hunkStarts(line) else {
					inHunk = false
					continue
				}
				inHunk = true
				(expectedLine, actualLine) = starts
				continue
			}

			// Ignore every line before the first hunk (denoted by @@) as it is
			// patch metadata, which when using `--no-index` is two explicit file
			// paths which were provided by the test; the expected output
			// reference file and a temp file with the actual output.
			guard inHunk, let marker = line.first else { continue }

			// Whitespace failures are hard to grok with a standard no-colour
			// pipe; so just in case it's a whitespace issue this will eagerly
			// replace the invisibles with symbols
			switch marker {
			case " ":
				finishCurrent()
				expectedLine += 1
				actualLine += 1
			case "-":
				current = current ?? Change(expectedStart: expectedLine, actualStart: actualLine)
				current?.expectedCount += 1
				current?.lines.append(_visualizeWhitespace(line))
				expectedLine += 1
			case "+":
				current = current ?? Change(expectedStart: expectedLine, actualStart: actualLine)
				current?.actualCount += 1
				current?.lines.append(_visualizeWhitespace(line))
				actualLine += 1
			default:
				// "\ No newline at end of file" belongs to the line above it.
				current?.lines.append(String(line))
			}
		}

		finishCurrent()
		return changes
	}

	/// Reads the first reference and output line numbers from a hunk header.
	private static func _hunkStarts(_ header: Substring) -> (expected: Int, actual: Int)? {
		// Hunk start format:
		// @@ -12,3 +12,4 @@ optional context
		guard let ranges = header.split(separator: "@@").first?.split(separator: " "),
			  ranges.count == 2,
			  let expected = _hunkStart(ranges[0]),
			  let actual = _hunkStart(ranges[1])
		else {
			return nil
		}

		return (expected, actual)
	}

	/// Reads a header range such as `-12,3`, `+12` or `-12,0`. When the count is 0, git
	/// reports the line *before* the gap, so the first affected line is the next one.
	private static func _hunkStart(_ range: Substring) -> Int? {
		let parts = range.dropFirst().split(separator: ",", omittingEmptySubsequences: false)	// drop the - or + sign
		guard let start = parts.first.flatMap({ Int($0) }) else {
			return nil
		}

		let count = parts.dropFirst().first.flatMap { Int($0) } ?? 1
		return count == 0 ? start + 1 : start
	}

	private static func _visualizeWhitespace(_ line: Substring) -> String {
		guard let first = line.first, first == "+" || first == "-" || first == " " else {
			return String(line)
		}
		let remaining = line.dropFirst()
			.map {
				switch $0 {
				case "\t": "»   "
				case " ": "·"
				default: String($0)
				}
			}
			.joined()
		return String(first) + remaining
	}

	private struct GitResult {
		let rawOutput: String
		let changes: [Change]
		let hasDifferences: Bool
	}

	private struct Change {
		let expectedStart: Int
		let actualStart: Int
		var expectedCount = 0
		var actualCount = 0
		var lines: [String] = []

		var body: String {
			lines.joined(separator: "\n")
		}

		func summary(isWhitespaceOnly: Bool) -> String {
			let expected = expectedCount == 1
			? "line \(expectedStart)"
			: "lines \(expectedStart)-\(expectedStart + max(expectedCount, 1) - 1)"
			let actual = actualCount == 1
			? "line \(actualStart)"
			: "lines \(actualStart)-\(actualStart + max(actualCount, 1) - 1)"

			if isWhitespaceOnly {
				let location = expectedCount > 0
				? "reference \(expected)"
				: "output \(actual)"
				return "Whitespace differs at \(location); check tabs, spaces, and string literals."
			}

			switch (expectedCount, actualCount) {
			case let (0, added):
				let (extra, place, joiner) = added == 1
				? ("an extra line", String(actualStart), "is")
				: ("\(added) extra lines", "\(actualStart)-\(actualStart + added - 1)", "are")
				return "Output has \(extra) at \(place) that \(joiner) not in the reference."
			case (_, 0):
				return "Output is missing reference \(expected)."
			case let (removed, added) where removed == added:
				return removed == 1
				? "Line \(expectedStart) differs from the reference."
				: "Lines \(expectedStart)-\(expectedStart + removed - 1) differ from the reference."
			default:
				return "Reference \(expected) became \(actual) in the output."
			}
		}
	}

	private struct GitDiffError: Error, CustomStringConvertible {
		let terminationStatus: Int32
		let output: String

		var description: String {
			"""
			git diff failed with exit status \(terminationStatus).

			\(output)
			"""
		}
	}
}

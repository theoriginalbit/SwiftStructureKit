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
	static func assert(
		_ actual: some ConvertibleToData,
		matches expected: some ConvertibleToData,
		attachmentName: String? = nil,
		sourceLocation: SourceLocation = #_sourceLocation,
	) throws {
		let actual = actual.convertToData()
		let expected = expected.convertToData()
		let attachmentName = attachmentName ?? UUID().uuidString
		_recordAttachment(actual, attachmentName: "\(attachmentName)_actual", sourceLocation: sourceLocation)
		_recordAttachment(expected, attachmentName: "\(attachmentName)_expected", sourceLocation: sourceLocation)

		guard actual != expected else {
			return
		}

		// Outputs were different, let's find out why. We're going
		// to use Git, so will need to write the results to a file.
		let actualURL = try _writeToFile(actual)
		defer { try? FileManager.default.removeItem(at: actualURL) }

		let expectedURL = try _writeToFile(expected)
		defer { try? FileManager.default.removeItem(at: expectedURL) }

		try _assert(
			actualURL,
			matches: expectedURL,
			sourceLocation: sourceLocation,
		)
	}

	static func assert(
		_ actual: some ConvertibleToData,
		matches expectedURL: URL,
		sourceLocation: SourceLocation = #_sourceLocation,
	) throws {
		let actual = actual.convertToData()
		_recordAttachment(actual, sourceLocation: sourceLocation)

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
			sourceLocation: sourceLocation,
		)
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
		let hint = whitespaceDiff.hasDifferences
			? "Generated output does not match reference."
			: "Differences disappear when whitespace is ignored; check whitespace, including inside string literals."

		Issue.record(
			"""
			\(hint)
			\(diff.output)
			""",
			sourceLocation: sourceLocation,
		)
	}

	private static func _gitDiff(
		expected: URL,
		actual: URL,
		ignoringWhitespace: Bool = false,
	) throws -> (output: String, hasDifferences: Bool) {
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
		return (
			output: _format(diff),
			hasDifferences: process.terminationStatus == 1,
		)
	}

	@ArrayBuilder<String>
	private static func _gitArguments(ignoresWhitespace: Bool, expected: URL, actual: URL) -> [String] {
		"diff"
		"--no-index"
		"--no-color" // in case color.ui = always is set globally
		"--diff-algorithm=histogram"
		"--unified=0" // changed lines only, no surrounding context
		if ignoresWhitespace {
			"--ignore-all-space"
		}
		"--"
		expected.path
		actual.path
	}

	private static func _format(_ diff: String) -> String {
		var lines: [String] = []
		var inHunk  = false
		for line in diff.split(separator: "\n", omittingEmptySubsequences: true) {
			if line.hasPrefix("@@") {
				inHunk = true
				lines.append(_hunkHeader(line))
				continue
			}

			// Ignore every line before the first hunk (denoted by @@) as it is
			// patch metadata, which when using `--no-index` is two explicit file
			// paths which were provided by the test; the expected output
			// reference file and a temp file with the actual output.
			guard inHunk else { continue }

			// Whitespace failures are hard to grok with a standard no-colour
			// pipe; so just in case it's a whitespace issue this will eagerly
			// replace the invisibles with symbols
			lines.append(_visualizeWhitespace(line))
		}

		return lines.joined(separator: "\n")
	}

	private static func _hunkHeader(_ line: Substring) -> String {
		// Hunk start format:
		// @@ -12,3 +12,4 @@ optional context
		guard let numbers = line.split(separator: "@@").first?.split(separator: " "),
			  numbers.count == 2,
			  let expectedLine = Int(numbers[0].dropFirst().prefix(while: \.isNumber)),	// drop - sign and read up to column marker (,)
			  let actualLine = Int(numbers[1].dropFirst().prefix(while: \.isNumber))	// drop + sign and read up to column marker (,)
		else {
			return "@@"
		}

		return "@@ Expected line \(expectedLine); Actual line \(actualLine) @@"
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

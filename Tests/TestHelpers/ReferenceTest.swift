//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing

enum ReferenceTest {
	static func assert(
		_ actual: Data,
		matches expectedURL: URL,
		attachmentName: String? = nil,
		sourceLocation: SourceLocation = #_sourceLocation,
	) throws {
		// Make the generated output available in the test results.
		// Note to self: successful tests will delete
		//               attachments (configurable by test plans)
		Attachment.record(
			String(decoding: actual, as: UTF8.self),
			named: attachmentName ?? expectedURL.lastPathComponent,
			sourceLocation: sourceLocation
		)

		let expected = try Data(contentsOf: expectedURL)
		guard actual != expected else {
			return
		}

		// Outputs were different, let's find out why. We're going
		// to use Git, so will need to write the actual results to
		// a file.
		let actualURL = FileManager.default.temporaryDirectory
			.appending(component: UUID().uuidString)
			.appendingPathExtension(expectedURL.pathExtension)

		defer {
			try? FileManager.default.removeItem(at: actualURL)
		}

		try actual.write(to: actualURL)

		let diff = try gitDiff(
			expected: expectedURL,
			actual: actualURL
		)

		Issue.record(
			"""
			Generated output does not match reference.
			\(diff)
			""",
			sourceLocation: sourceLocation
		)
	}

	private static func gitDiff(
		expected: URL,
		actual: URL,
	) throws -> String {
		let process = Process()
		let output = Pipe()
		let error = Pipe()

		process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
		process.arguments = [
			"diff",
			"--no-index",
			"--no-color",     // in case color.ui = always is set globally
			"--unified=0",    // changed lines only, no surrounding context
			"--",
			expected.path,
			actual.path,
		]
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
				output: String(decoding: errorData, as: UTF8.self)
			)
		}

		let diff = String(decoding: data, as: UTF8.self)
		print(diff)
		return format(diff)
	}

	private static func format(_ diff: String) -> String {
		var lines: [String] = []
		var inHunk  = false
		for line in diff.split(separator: "\n", omittingEmptySubsequences: true) {
			if line.hasPrefix("@@") {
				inHunk = true
				lines.append(hunkHeader(line))
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
			lines.append(visualizeWhitespace(line))
		}

		return lines.joined(separator: "\n")
	}

	private static func hunkHeader(_ line: Substring) -> String {
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

	private static func visualizeWhitespace(_ line: Substring) -> String {
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

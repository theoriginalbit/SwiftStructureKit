//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import enum SwiftStructureKit.ArrayBuilder
import Testing

final class LockedBuffer: @unchecked Sendable {
	private let lock = NSLock()
	private var data = Data()
	func append(_ d: Data) { lock.lock(); data.append(d); lock.unlock() }
	var string: String { lock.lock(); defer { lock.unlock() }; return String(decoding: data, as: UTF8.self) }
}

enum CompilerTest {
	static func compile(
		_ sources: some Collection<URL>,
		flags: [String],
	) throws -> String {
		let process = Process()
		let output = Pipe()
		let error = Pipe()

		process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
		process.arguments = _swiftCArguments(
			flags: flags,
			buildDir: _buildDir(),
			filePaths: sources.map { $0.path() }
		)
		process.standardOutput = output
		process.standardError = error

		try process.run()

		let data = output.fileHandleForReading.readDataToEndOfFile()
		let errorData = error.fileHandleForReading.readDataToEndOfFile()
		process.waitUntilExit()

		guard process.terminationStatus == 0 else {
			throw CompilationError(
				terminationStatus: process.terminationStatus,
				output: String(decoding: errorData, as: UTF8.self),
			)
		}

		return String(decoding: data, as: UTF8.self)
	}

	static func assert(
		_ result: String,
		diagnostics expected: [DiagnosticSpec],
		sourceLocation: SourceLocation,
	) throws {
		var actual = _parse(result).filter { $0.severity != "note" }

		for spec in expected {
			func matches(_ diagnostic: Diagnostic) -> Bool {
				diagnostic.severity == spec.severity
					&& diagnostic.line == (spec.line ?? diagnostic.line)
					&& diagnostic.column == (spec.column ?? diagnostic.column)
					&& spec.anyOf.contains { diagnostic.message.contains($0) }
			}

			if actual.contains(where: matches(_:))  {
				actual.removeAll(where: matches(_:))
			} else {
				Issue.record(
					"Missing \(spec.severity) at \(spec.line.map(String.init) ?? "any"):\(spec.column.map(String.init) ?? "any"): \(spec.anyOf)",
					sourceLocation: sourceLocation
				)
			}
		}
		// Anything left is unexpected, including "no such module", so a broken harness can't pass silently
		for diagnostic in actual {
			Issue.record(
				"Unexpected \(diagnostic.severity) at \(diagnostic.line):\(diagnostic.column): \(diagnostic.message)",
				sourceLocation: sourceLocation
			)
		}
		let expectsError = expected.contains { $0.severity == "error" }
		if expectsError {
			Issue.record("Source compiled but errors were expected", sourceLocation: sourceLocation)
		}
	}

	private static func _buildDir() -> String {
		// cannot use Bundle.module otherwise the code being compiled cannot import the SwiftStructureKit module
		return Bundle(for: BundleLocator.self).bundleURL.deletingLastPathComponent().path()
	}

	@ArrayBuilder<String>
	private static func _swiftCArguments(flags: [String], buildDir: String, filePaths: [String]) -> [String] {
		"swiftc"
		"-typecheck"
		"-diagnostic-style"
		"llvm"
		flags
		"-I"
		buildDir
		"-I"
		buildDir + "/Modules"
		filePaths
	}

	private static func _parse(_ output: String) -> [Diagnostic] {
		let pattern = #/(.+\.swift):(\d+):(\d+): (error|warning|note): (.+)/#
		return output.split(separator: "\n").compactMap { line in
			guard let match = line.firstMatch(of: pattern),
				  let line = Int(match.2), let column = Int(match.3)
			else { return nil }
			return Diagnostic(line: line, column: column, severity: String(match.4), message: String(match.5))
		}
	}

	private struct CompilationError: Error, CustomStringConvertible {
		let terminationStatus: Int32
		let output: String

		var description: String {
			"""
			compilation failed with exit status \(terminationStatus).

			\(output)
			"""
		}
	}
}

private final class BundleLocator {}

private struct Diagnostic {
	let line: Int
	let column: Int
	let severity: String
	let message: String
}

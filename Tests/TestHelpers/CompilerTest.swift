//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
import Foundation
import SwiftStructureKit

struct DiagnosticSpec {
	var anyOf: [String]
	var line: Int? = nil
	var column: Int? = nil
	var severity = "error"
}

func assertCompilation(
	_ source: String,
	flags: [String] = [],
	diagnostics expected: [DiagnosticSpec] = [],
	sourceLocation: SourceLocation = #_sourceLocation
) throws {
	try CompilerTest.assertCompilation(
		source,
		flags: flags,
		diagnostics: expected,
		sourceLocation: sourceLocation,
	)
}

enum CompilerTest {
	static func assertCompilation(
		_ source: String,
		flags: [String] = [],
		diagnostics expected: [DiagnosticSpec] = [],
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		let result = try _run(source, flags: flags)
		var actual = _parse(result.output).filter { $0.severity != "note" }

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
		if expectsError && result.ok {
			Issue.record("Source compiled but errors were expected", sourceLocation: sourceLocation)
		}
	}

	private static func _buildDir() -> String {
		// cannot use Bundle.module otherwise the code being compiled cannot import the SwiftStructureKit module
		return Bundle(for: BundleLocator.self).bundleURL.deletingLastPathComponent().path()
	}

	private static func _run(_ source: String, flags: [String]) throws -> (ok: Bool, output: String) {
		let fileManager = FileManager.default
		let tempDir = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
		defer { try? fileManager.removeItem(at: tempDir) }
		let file = tempDir.appendingPathComponent("code.swift")
		try source.write(to: file, atomically: true, encoding: .utf8)

		let build = _buildDir()
		let process = Process()
		process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
		process.arguments = _swiftCArguments(
			flags: flags,
			buildDir: build,
			filePath: file.path(),
		)
		let pipe = Pipe()
		process.standardError = pipe
		process.standardOutput = pipe
		try process.run()
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		process.waitUntilExit()
		return (process.terminationStatus == 0, String(decoding: data, as: UTF8.self))
	}

	@ArrayBuilder<String>
	private static func _swiftCArguments(flags: [String], buildDir: String, filePath: String) -> [String] {
		"swiftc"
		"-typecheck"
		"-diagnostic-style"
		"llvm"
		flags
		"-I"
		buildDir
		"-I"
		buildDir + "/Modules"
		filePath
	}

	private static func _parse(_ output: String) -> [Diagnostic] {
		let pattern = #/code\.swift:(\d+):(\d+): (error|warning|note): (.+)/#
		return output.split(separator: "\n").compactMap { line in
			guard let match = line.firstMatch(of: pattern),
				  let line = Int(match.1), let column = Int(match.2)
			else { return nil }
			return Diagnostic(line: line, column: column, severity: String(match.3), message: String(match.4))
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

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing

public func assertCompilation(
	_ source: URL,
	flags: [String] = [],
	diagnostics expected: [DiagnosticSpec] = [],
	sourceLocation: SourceLocation = #_sourceLocation
) async {
	do {
		try await AttachmentRecorder.record(source, sourceLocation: sourceLocation)
		let result = try CompilerTest.compile(CollectionOfOne(source), flags: flags)
		try CompilerTest.assert(result, diagnostics: expected, sourceLocation: sourceLocation)
	} catch {
		Issue.record(error, sourceLocation: sourceLocation)
	}
}

public func assertCompilation(
	_ sources: some Collection<URL>,
	flags: [String] = [],
	diagnostics expected: [DiagnosticSpec] = [],
	sourceLocation: SourceLocation = #_sourceLocation
) async {
	do {
		for source in sources {
			try await AttachmentRecorder.record(source, sourceLocation: sourceLocation)
		}
		let result = try CompilerTest.compile(sources, flags: flags)
		try CompilerTest.assert(result, diagnostics: expected, sourceLocation: sourceLocation)
	} catch {
		Issue.record(error, sourceLocation: sourceLocation)
	}
}

public func assertCompilation(
	_ sources: URL...,
	flags: [String] = [],
	diagnostics expected: [DiagnosticSpec] = [],
	sourceLocation: SourceLocation = #_sourceLocation
) async {
	await assertCompilation(sources, flags: flags, diagnostics: expected, sourceLocation: sourceLocation)
}

public func assertCompilation(
	_ source: some ConvertibleToString,
	flags: [String] = [],
	diagnostics expected: [DiagnosticSpec] = [],
	sourceLocation: SourceLocation = #_sourceLocation
) async {
	do {
		let tempDir = try TempDir.create()
		defer { try? FileManager.default.removeItem(at: tempDir) }

		let data = source.convertToString()
		let outputURL = tempDir.appending(component: "\(UUID().uuidString).swift", directoryHint: .notDirectory)
		try data.write(to: outputURL, atomically: true, encoding: .utf8)
		try await AttachmentRecorder.record(outputURL, sourceLocation: sourceLocation)

		let result = try CompilerTest.compile(CollectionOfOne(outputURL), flags: flags)
		try CompilerTest.assert(result, diagnostics: expected, sourceLocation: sourceLocation)
	} catch {
		Issue.record(error, sourceLocation: sourceLocation)
	}
}

public func assertCompilation(
	_ sources: some Collection<some ConvertibleToString>,
	flags: [String] = [],
	diagnostics expected: [DiagnosticSpec] = [],
	sourceLocation: SourceLocation = #_sourceLocation
) async {
	do {
		let tempDir = try TempDir.create()
		defer { try? FileManager.default.removeItem(at: tempDir) }

		var outputURLs: [URL] = []
		for source in sources {
			let data = source.convertToString()
			let outputURL = tempDir.appending(component: "\(UUID().uuidString).swift", directoryHint: .notDirectory)
			try data.write(to: outputURL, atomically: true, encoding: .utf8)
			try await AttachmentRecorder.record(outputURL, sourceLocation: sourceLocation)
			outputURLs.append(outputURL)
		}

		let result = try CompilerTest.compile(outputURLs, flags: flags)
		try CompilerTest.assert(result, diagnostics: expected, sourceLocation: sourceLocation)
	} catch {
		Issue.record(error, sourceLocation: sourceLocation)
	}
}

public func assertCompilation<Source: ConvertibleToString>(
	_ sources: Source...,
	flags: [String] = [],
	diagnostics expected: [DiagnosticSpec] = [],
	sourceLocation: SourceLocation = #_sourceLocation
) async {
	await assertCompilation(sources, flags: flags, diagnostics: expected, sourceLocation: sourceLocation)
}

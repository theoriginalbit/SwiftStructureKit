//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing

/// Compares two in-memory values.
///
/// Use this when both values are large and difficult to compare in the standard test output.
/// A failure reports a line-based diff with whitespace made visible.
public func expectRendered(
	_ actual: some ConvertibleToData,
	equals expected: some ConvertibleToData,
	attachmentName: String? = nil,
	sourceLocation: SourceLocation = #_sourceLocation,
) {
	do {
		let actual = actual.convertToData()
		let expected = expected.convertToData()

		let attachmentName = attachmentName ?? UUID().uuidString
		AttachmentRecorder.record(actual, attachmentName: "\(attachmentName)_actual.swift", sourceLocation: sourceLocation)
		AttachmentRecorder.record(expected, attachmentName: "\(attachmentName)_expected.swift", sourceLocation: sourceLocation)

		guard actual != expected else {
			return
		}

		// Outputs were different, let's find out why. We're going
		// to use Git, so will need to write the results to a file.
		let actualURL = try GitDiffTest.writeToFile(actual)
		defer { try? FileManager.default.removeItem(at: actualURL) }

		let expectedURL = try GitDiffTest.writeToFile(expected)
		defer { try? FileManager.default.removeItem(at: expectedURL) }

		try GitDiffTest.assert(
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
/// Use this when both values are large and difficult to compare in the standard test output.
/// A failure reports a line-based diff with whitespace made visible.
public func expectRendered(
	_ actual: some ConvertibleToData,
	equals expectedURL: URL,
	sourceLocation: SourceLocation = #_sourceLocation,
) {
	do {
		let actual = actual.convertToData()

		let fixtureName = expectedURL.deletingPathExtension().lastPathComponent
		AttachmentRecorder.record(actual, attachmentName: "\(fixtureName)_actual.swift", sourceLocation: sourceLocation)

		// Let's write the actual results to file and use Git
		// to find out if there are differences
		let actualURL = try GitDiffTest.writeToFile(actual)
		defer { try? FileManager.default.removeItem(at: actualURL) }

		try GitDiffTest.assert(
			actualURL,
			matches: expectedURL,
			attachmentName: fixtureName,
			sourceLocation: sourceLocation,
		)
	} catch {
		Issue.record(error, sourceLocation: sourceLocation)
	}
}

/// Compares a value loaded from disk against an in-memory value.
///
/// The actual output is attached to this test run so that it can be found in the test results in the event of failure.
///
/// Use this when both values are large and difficult to compare in the standard test output.
/// A failure reports a line-based diff with whitespace made visible.
public func expectRendered(
	_ actualURL: URL,
	equals expected: some ConvertibleToData,
	sourceLocation: SourceLocation = #_sourceLocation,
) async {
	do {
		let expected = expected.convertToData()

		try await AttachmentRecorder.record(actualURL, sourceLocation: sourceLocation)
		AttachmentRecorder.record(
			expected,
			attachmentName: "\(actualURL.deletingPathExtension().lastPathComponent)_expected.swift",
			sourceLocation: sourceLocation
		)

		// Let's write the expected results to file and use Git
		// to find out if there are differences
		let expectedURL = try GitDiffTest.writeToFile(expected)
		defer { try? FileManager.default.removeItem(at: expectedURL) }

		try GitDiffTest.assert(
			actualURL,
			matches: expectedURL,
			attachmentName: nil,
			sourceLocation: sourceLocation,
		)
	} catch {
		Issue.record(error, sourceLocation: sourceLocation)
	}
}

/// Compares a value loaded from disk against an in-memory value.
///
/// The actual output is attached to this test run so that it can be found in the test results in the event of failure.
///
/// Use this when both values are large and difficult to compare in the standard test output.
/// A failure reports a line-based diff with whitespace made visible.
public func expectRendered(
	_ actualURL: URL,
	equals expectedURL: URL,
	sourceLocation: SourceLocation = #_sourceLocation,
) async {
	do {
		try await AttachmentRecorder.record(actualURL, sourceLocation: sourceLocation)
		try GitDiffTest.assert(
			actualURL,
			matches: expectedURL,
			attachmentName: nil,
			sourceLocation: sourceLocation,
		)
	} catch {
		Issue.record(error, sourceLocation: sourceLocation)
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing

public enum AttachmentRecorder {
	static func record(
		_ data: some ConvertibleToString,
		attachmentName: String,
		sourceLocation: SourceLocation,
	) {
		// Make the generated output available in the test results.
		// Note to self: successful tests will delete
		//               attachments (configurable by test plans)
		Attachment.record(
			data.convertToString(),
			named: attachmentName,
			sourceLocation: sourceLocation,
		)
	}

	static func record(
		_ fileURL: URL,
		attachmentName: String? = nil,
		sourceLocation: SourceLocation,
	) async throws {
		// Make the generated output available in the test results.
		// Note to self: successful tests will delete
		//               attachments (configurable by test plans)
		let attachment = try await Attachment(
			contentsOf: fileURL,
			named: attachmentName,
			sourceLocation: sourceLocation
		)
		Attachment.record(attachment, sourceLocation: sourceLocation)
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A comment rendered at the beginning of a Swift source file.
public struct FileHeaderCommentDescriptor: Sendable {
	/// The text of the file header comment.
	public let value: String

	/// Creates a file header comment from its text.
	///
	/// - Parameter value: The text to render at the beginning of the file.
	public init(_ value: String) {
		self.value = value
	}
}

extension FileHeaderCommentDescriptor: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.init(value)
	}
}

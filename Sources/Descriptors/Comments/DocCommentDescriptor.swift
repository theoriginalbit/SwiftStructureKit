//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A documentation comment.
public struct DocCommentDescriptor: Sendable {
	/// The text of the documentation comment, without comment delimiters.
	public let value: String

	/// Creates a documentation comment from its text.
	///
	/// - Parameter value: The documentation text.
	public init(_ value: String) {
		self.value = value
	}
}

extension DocCommentDescriptor: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.init(value)
	}
}

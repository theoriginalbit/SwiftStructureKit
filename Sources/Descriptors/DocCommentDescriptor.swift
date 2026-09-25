//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A documentation comment.
public struct DocCommentDescriptor: Sendable {
	public let value: String

	public init(_ value: String) {
		self.value = value
	}
}

extension DocCommentDescriptor: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.value = value
	}
}

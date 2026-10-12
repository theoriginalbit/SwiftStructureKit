//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An inline comment.
public struct InlineCommentDescriptor: Sendable {
	public let value: String

	public init(_ value: String) {
		self.value = value
	}
}

extension InlineCommentDescriptor: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.value = value
	}
}

extension ArrayBuilder where T == StatementDescriptor {
	public static func buildExpression(_ expression: InlineCommentDescriptor) -> Result {
		[.comment(expression)]
	}
}

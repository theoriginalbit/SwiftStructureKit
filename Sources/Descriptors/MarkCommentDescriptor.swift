//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A mark comment. With an optional section break (`-`).
public struct MarkCommentDescriptor: Sendable {
	public let value: String?
	public let sectionBreak: Bool

	public init(_ value: String?, sectionBreak: Bool = false) {
		self.value = value
		self.sectionBreak = sectionBreak
	}
}

extension MarkCommentDescriptor: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.value = value
		self.sectionBreak = false // It's raw input, the provider will have to add the -
	}
}


//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A mark comment. With an optional section break (`-`).
public struct MarkCommentDescriptor: Sendable {
	/// The optional text displayed in the mark comment.
	public let value: String?

	/// Whether to render a section break after the mark text.
	public let sectionBreak: Bool

	/// Creates a mark comment.
	///
	/// - Parameters:
	///   - value: The optional text to display.
	///   - sectionBreak: Whether the mark should include a section break.
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

public extension TypeMemberDescriptor {
	/// Creates a mark-comment member.
	///
	/// - Parameters:
	///   - value: The optional mark text.
	///   - sectionBreak: Whether to render a section break after the text.
	/// - Returns: A type member containing the mark comment.
	static func mark(_ value: String?, sectionBreak: Bool = false) -> Self {
		Self.mark(MarkCommentDescriptor(value, sectionBreak: sectionBreak))
	}
}

public extension ArrayBuilder<TypeMemberDescriptor> {
	static func buildExpression(_ expression: MarkCommentDescriptor) -> [T] {
		[.mark(expression)]
	}
}

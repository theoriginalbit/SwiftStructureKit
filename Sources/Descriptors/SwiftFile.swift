//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import Foundation

/// A descriptor representing a generated Swift source file.
public struct SwiftFile: Sendable {
	/// The comment rendered at the beginning of the file, if any.
	public let headerComment: FileHeaderCommentDescriptor?

	/// The top-level declarations contained in the file.
	public let declarations: [TypeMemberDescriptor]

	/// Creates a file descriptor using a result builder to define its declarations.
	///
	/// - Parameters:
	///   - headerComment: An optional comment rendered at the beginning of the file.
	///   - declarations: A result builder closure producing the declarations contained in the file.
	public init(
		headerComment: FileHeaderCommentDescriptor? = nil,
		@TypeMembersBuilder declarations: () -> [TypeMemberDescriptor],
	) {
		self.headerComment = headerComment
		self.declarations = declarations()
	}

	/// Renders the file descriptor as UTF-8 source data.
	public func render(indentUsing style: CodeIndentStyle = .spaces(4)) -> Data {
		var writer = CodeWriter(indentUsing: style)
		FileRenderer.render(self, to: &writer)
		return writer.rendered()
	}

	/// Renders the file descriptor directly to the specified file URL.
	///
	/// - Parameters:
	///   - url: The destination file URL.
	///   - style: The indentation style to use when rendering.
	/// - Throws: An error if the rendered data cannot be written to the destination.
	public func render(
		to url: URL,
		indentUsing style: CodeIndentStyle = .spaces(4),
	) throws {
		try render(indentUsing: style).write(to: url, options: .atomic)
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import Foundation

/// A descriptor representing a generated Swift source file.
public struct SwiftFile: Sendable {
	/// The comment rendered at the beginning of the file, if any.
	public let headerComment: FileHeaderCommentDescriptor?

	/// The modules imported by the file.
	public let imports: [ImportDescriptor]

	/// The top-level declarations contained in the file.
	public let declarations: [TopLevelDeclarationDescriptor]

	/// Creates a file descriptor using a result builder to define its declarations.
	///
	/// The builder accepts every descriptor a type body does (``DeclarationBuilder``), plus
	/// an ``ExpressionDescriptor`` which is only permitted at the file scope.
	///
	/// - Parameters:
	///   - headerComment: An optional comment rendered at the beginning of the file.
	///   - imports: The imports rendered before the file's declarations.
	///   - declarations: A result builder closure producing the declarations contained in the file.
	public init(
		headerComment: FileHeaderCommentDescriptor? = nil,
		imports: [ImportDescriptor] = [],
		@TopLevelDeclarationBuilder declarations: () -> [TopLevelDeclarationDescriptor],
	) {
		self.headerComment = headerComment
		self.imports = imports
		self.declarations = declarations()
	}

	/// Renders the file descriptor as UTF-8 source data.
	///
	/// - Parameter style: The indentation style to use when rendering.
	/// - Returns: The rendered source as UTF-8 `Data`.
	public func render(indentUsing style: CodeIndentStyle = .spaces(4)) -> Data {
		var writer = CodeWriter(indentUsing: style)
		SwiftFileRenderer.render(self, to: &writer)
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

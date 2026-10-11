//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A code block is an intermediate storage for 0 or more statements.
public struct CodeBlockDescriptor: Sendable {
	/// A result builder for constructing code blocks.
	public typealias Builder = ArrayBuilder<StatementDescriptor>

	/// The statements contained within the code block.
	public let statements: Builder.Result

	/// Creates a code block using a result builder.
	public init(@Builder _ builder: () -> Builder.Result) {
		self.statements = builder()
	}
}

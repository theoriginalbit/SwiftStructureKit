//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A code block is an intermediate storage for 0 or more statements.
public struct CodeBlockDescriptor: Sendable {
	/// The statements contained within the code block.
	public let statements: CodeBlockBuilder.Result

	/// Creates a code block with an array of statements.
	public init(statements: CodeBlockBuilder.Result = []) {
		self.statements = statements
	}

	/// Creates a code block using a result builder.
	public init(@CodeBlockBuilder _ builder: () -> CodeBlockBuilder.Result) {
		self.statements = builder()
	}
}

/// A result builder for constructing code blocks.
public typealias CodeBlockBuilder = ArrayBuilder<StatementDescriptor>

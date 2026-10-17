//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A code block is an intermediate storage for 0 or more statements.
public struct CodeBlockDescriptor: Sendable {
	/// The statements contained within the code block.
	public let statements: [StatementDescriptor]

	/// Creates a code block from an array of statements.
	///
	/// - Parameter statements: The statements in the block.
	public init(_ statements: [StatementDescriptor]) {
		self.statements = statements
	}

	/// Creates a code block using a result builder.
	///
	/// - Parameter builder: A builder closure producing the statements in the block.
	public init(@CodeBlockBuilder _ builder: () -> [StatementDescriptor]) {
		self.statements = builder()
	}
}

extension CodeBlockDescriptor: ExpressibleByArrayLiteral {
	/// Creates a code block from an array literal of statements.
	public init(arrayLiteral elements: StatementDescriptor...) {
		self.statements = elements
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A code block is an intermediate storage for 0 or more statements.
public struct CodeBlockDescriptor: Sendable {
	/// The statements contained within the code block.
	public let statements: [StatementDescriptor]

	/// Creates a code block using a result builder.
	public init(@CodeBlockBuilder _ builder: () -> [StatementDescriptor]) {
		self.statements = builder()
	}
}

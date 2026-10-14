//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An `if` statement with its `else if` branches and terminal `else` branch.
public struct IfElseStatementDescriptor: Sendable {
	let branches: [IfStatementDescriptor.Branch]
	let elseBody: CodeBlockDescriptor
}

public extension StatementDescriptor {
	/// Creates an `if` statement with an `else` branch.
	static func `if`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder _ body: () -> [StatementDescriptor],
		@CodeBlockBuilder `else` elseBody: () -> [StatementDescriptor],
	) -> IfElseStatementDescriptor {
		IfElseStatementDescriptor(
			branches: [
				IfStatementDescriptor.Branch(
					condition: condition,
					body: CodeBlockDescriptor(body)
				),
			],
			elseBody: CodeBlockDescriptor(elseBody)
		)
	}
}

extension ArrayBuilder where T == StatementDescriptor {
	public static func buildExpression(_ expression: IfElseStatementDescriptor) -> Result {
		[.ifElse(expression)]
	}
}

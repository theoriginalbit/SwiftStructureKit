//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An `if` statement with its `else if` branches.
public struct IfStatementDescriptor: Sendable {
	struct Branch: Sendable {
		let condition: ExpressionDescriptor
		let body: CodeBlockDescriptor
	}

	let branches: [Branch]

	init(condition: ExpressionDescriptor, body: CodeBlockDescriptor) {
		branches = [Branch(condition: condition, body: body)]
	}

	private init(branches: [Branch]) {
		self.branches = branches
	}

	/// Appends an `else if` branch.
	public func elseIf(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder body: () -> [StatementDescriptor],
	) -> Self {
		let branch = Branch(condition: condition, body: CodeBlockDescriptor(body))
		return Self(branches: branches + CollectionOfOne(branch))
	}

	/// Appends the terminal `else` branch.
	public func `else`(
		@CodeBlockBuilder body: () -> [StatementDescriptor],
	) -> IfElseStatementDescriptor {
		IfElseStatementDescriptor(
			branches: branches,
			elseBody: CodeBlockDescriptor(body),
		)
	}
}

public extension StatementDescriptor {
	/// Creates an `if` statement.
	static func `if`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder body: () -> [StatementDescriptor],
	) -> IfStatementDescriptor {
		IfStatementDescriptor(
			condition: condition,
			body: CodeBlockDescriptor(body),
		)
	}
}

extension ArrayBuilder where T == StatementDescriptor {
	public static func buildExpression(_ expression: IfStatementDescriptor) -> Result {
		[.`if`(expression)]
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An `if` statement with its `else if` branches and terminal `else` branch.
public struct IfElseStatementDescriptor: Sendable {
	/// The `if` branch followed by any `else if` branches, in source order.
	public let branches: [IfStatementDescriptor.Branch]

	/// The statements executed when no branch condition holds.
	public let elseBody: CodeBlockDescriptor

	/// Creates an `if` statement with a terminal `else` branch.
	///
	/// - Parameters:
	///   - branches: The `if` branch followed by any `else if` branches. Must not be empty.
	///   - elseBody: The statements executed when no branch condition holds.
	public init(branches: [IfStatementDescriptor.Branch], elseBody: CodeBlockDescriptor) {
		precondition(!branches.isEmpty, "An if statement requires at least one branch.")
		self.branches = branches
		self.elseBody = elseBody
	}
}

public extension ConditionalStatementDescriptor {
	/// Creates an `if` statement with an `else` branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	///   - elseBody: A result builder closure producing the statements executed when the condition does not hold.
	static func `if`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder _ body: () -> [StatementDescriptor],
		@CodeBlockBuilder `else` elseBody: () -> [StatementDescriptor],
	) -> Self {
		.ifElse(IfElseStatementDescriptor(
			branches: [
				IfStatementDescriptor.Branch(
					condition: condition,
					body: CodeBlockDescriptor(body)
				),
			],
			elseBody: CodeBlockDescriptor(elseBody)
		))
	}
}

public extension StatementDescriptor {
	/// Creates an `if` statement with an `else` branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	///   - elseBody: A result builder closure producing the statements executed when the condition does not hold.
	static func `if`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder _ body: () -> [StatementDescriptor],
		@CodeBlockBuilder `else` elseBody: () -> [StatementDescriptor],
	) -> Self {
		.conditional(.if(condition, body, else: elseBody))
	}
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: IfElseStatementDescriptor) -> Result {
		[.conditional(.ifElse(expression))]
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A `guard` statement.
public struct GuardStatementDescriptor: Sendable {
	/// The condition that must hold for execution to continue.
	public let condition: ExpressionDescriptor

	/// The statements in the `else` block, which must exit the enclosing scope.
	public let elseBody: CodeBlockDescriptor

	/// Creates a `guard` statement.
	///
	/// - Parameters:
	///   - condition: The condition that must hold for execution to continue.
	///   - elseBody: The statements in the `else` block.
	public init(condition: ExpressionDescriptor, elseBody: CodeBlockDescriptor) {
		self.condition = condition
		self.elseBody = elseBody
	}
}

public extension ConditionalStatementDescriptor {
	/// Creates a `guard` statement, and its required `else` body.
	///
	/// - Parameters:
	///   - condition: The condition that must hold for execution to continue.
	///   - elseBody: A result builder closure producing the statements in the `else` block.
	static func `guard`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder `else` elseBody: () -> [StatementDescriptor],
	) -> Self {
		.guard(GuardStatementDescriptor(
			condition: condition,
			elseBody: CodeBlockDescriptor(elseBody),
		))
	}
}

public extension StatementDescriptor {
	/// Creates a `guard` statement, and its required `else` body.
	///
	/// - Parameters:
	///   - condition: The condition that must hold for execution to continue.
	///   - elseBody: A result builder closure producing the statements in the `else` block.
	static func `guard`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder `else` elseBody: () -> [StatementDescriptor],
	) -> Self {
		.conditional(.guard(condition, else: elseBody))
	}
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: GuardStatementDescriptor) -> Result {
		[.conditional(.guard(expression))]
	}
}

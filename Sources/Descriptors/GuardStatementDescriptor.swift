//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A `guard` statement followed by its successful continuation.
public struct GuardStatementDescriptor: Sendable {
	/// The condition that must hold for execution to continue.
	public let condition: ExpressionDescriptor

	/// The statements rendered after the `guard`, executed when the condition holds.
	public let body: CodeBlockDescriptor

	/// The statements in the `else` block, which must exit the enclosing scope.
	public let elseBody: CodeBlockDescriptor

	/// Creates a `guard` statement.
	///
	/// - Parameters:
	///   - condition: The condition that must hold for execution to continue.
	///   - body: The statements rendered after the `guard`, executed when the condition holds.
	///   - elseBody: The statements in the `else` block.
	public init(condition: ExpressionDescriptor, body: CodeBlockDescriptor, elseBody: CodeBlockDescriptor) {
		self.condition = condition
		self.body = body
		self.elseBody = elseBody
	}
}

public extension StatementDescriptor {
	/// Creates a `guard` statement, its successful continuation, and its required `else` body.
	///
	/// - Parameters:
	///   - condition: The condition that must hold for execution to continue.
	///   - body: A result builder closure producing the statements rendered after the `guard`.
	///   - elseBody: A result builder closure producing the statements in the `else` block.
	static func `guard`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder _ body: () -> [StatementDescriptor],
		@CodeBlockBuilder `else` elseBody: () -> [StatementDescriptor],
	) -> Self {
		.guard(GuardStatementDescriptor(
			condition: condition,
			body: CodeBlockDescriptor(body),
			elseBody: CodeBlockDescriptor(elseBody),
		))
	}
}

extension ArrayBuilder where T == StatementDescriptor {
	public static func buildExpression(_ expression: GuardStatementDescriptor) -> Result {
		[.`guard`(expression)]
	}
}

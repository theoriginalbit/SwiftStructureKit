//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A `guard` statement followed by its successful continuation.
public struct GuardStatementDescriptor: Sendable {
	let condition: ExpressionDescriptor
	let body: CodeBlockDescriptor
	let elseBody: CodeBlockDescriptor
}

public extension StatementDescriptor {
	/// Creates a `guard` statement, its successful continuation, and its required `else` body.
	static func `guard`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder _ body: () -> [StatementDescriptor],
		@CodeBlockBuilder `else` elseBody: () -> [StatementDescriptor],
	) -> GuardStatementDescriptor {
		GuardStatementDescriptor(
			condition: condition,
			body: CodeBlockDescriptor(body),
			elseBody: CodeBlockDescriptor(elseBody),
		)
	}
}

extension ArrayBuilder where T == StatementDescriptor {
	public static func buildExpression(_ expression: GuardStatementDescriptor) -> Result {
		[.`guard`(expression)]
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for a conditional statement, such as an `if`/`else` chain or a `guard` statement.
public enum ConditionalStatementDescriptor: Sendable {
	/// An `if` statement with zero or more `else if` branches and no terminal `else` branch.
	///
	/// The associated descriptor stores the branches in source order.
	case `if`(IfStatementDescriptor)

	/// An `if` statement with zero or more `else if` branches and a terminal `else` branch.
	///
	/// The associated descriptor stores the conditional branches in source order and the body
	/// executed when none of their conditions hold.
	case ifElse(IfElseStatementDescriptor)

	/// A `guard` statement, its `else` body, and the continuation when its condition holds.
	///
	/// The associated descriptor stores the condition, the required `else` body, and the
	/// statements rendered after the `guard`.
	case `guard`(GuardStatementDescriptor)
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: ConditionalStatementDescriptor) -> Result {
		[.conditional(expression)]
	}
}

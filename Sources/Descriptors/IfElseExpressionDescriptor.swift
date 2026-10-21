//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An `if` expression with its `else if` branches and terminal `else` branch.
public struct IfElseExpressionDescriptor: Sendable {
	/// The `if` branch followed by any `else if` branches, in source order.
	public let branches: [IfExpressionDescriptor.Branch]

	/// The expression executed when no branch condition holds.
	public let elseBody: ExpressionDescriptor

	/// Creates an `if` expression with a terminal `else` branch.
	///
	/// - Parameters:
	///   - branches: The `if` branch followed by any `else if` branches. Must not be empty.
	///   - elseBody: The statements executed when no branch condition holds.
	public init(branches: [IfExpressionDescriptor.Branch], elseBody: ExpressionDescriptor) {
		precondition(!branches.isEmpty, "An if expression requires at least one branch.")
		self.branches = branches
		self.elseBody = elseBody
	}
}

public extension ExpressionDescriptor {
	/// Creates an `if` statement with an `else` branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	///   - elseBody: A result builder closure producing the statements executed when the condition does not hold.
	static func `if`(
		_ condition: ExpressionDescriptor,
		_ body: @autoclosure () -> ExpressionDescriptor,
		else elseBody: @autoclosure () -> ExpressionDescriptor,
	) -> Self {
		.ifElse(IfElseExpressionDescriptor(
			branches: [
				IfExpressionDescriptor.Branch(
					condition: condition,
					body: body()
				),
			],
			elseBody: elseBody()
		))
	}
}

extension ArrayBuilder<ExpressionDescriptor> {
	/// Allows an ``IfElseExpressionDescriptor`` to be used directly inside a code block builder, wrapping it in ``ExpressionDescriptor/ifElse(_:)``.
	///
	/// - Parameter expression: The `if`/`else` statement to include.
	public static func buildExpression(_ expression: IfElseExpressionDescriptor) -> Result {
		[.ifElse(expression)]
	}
}

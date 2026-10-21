//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An `if` expression with its `else if` branches.
public struct IfExpressionDescriptor: Sendable {
	/// A single conditional branch of an `if` expression.
	public struct Branch: Sendable {
		/// The condition that must hold for the branch to execute.
		public let condition: ExpressionDescriptor

		/// The expression result of this branch.
		public let body: ExpressionDescriptor

		/// Creates a conditional branch.
		///
		/// - Parameters:
		///   - condition: The condition that must hold for the branch to execute.
		///   - body: The expression result of this branch.
		public init(condition: ExpressionDescriptor, body: ExpressionDescriptor) {
			self.condition = condition
			self.body = body
		}
	}

	/// The `if` branch followed by any `else if` branches, in source order.
	public let branches: [Branch]

	/// Creates an `if` expression from its branches.
	///
	/// - Parameter branches: The `if` branch followed by any `else if` branches. Must not be empty.
	public init(branches: [Branch]) {
		precondition(!branches.isEmpty, "An if expression requires at least one branch.")
		self.branches = branches
	}

	/// Creates an `if` expression with a single branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: The expression result of this branch.
	public init(_ condition: ExpressionDescriptor, body: @autoclosure () -> ExpressionDescriptor) {
		self.init(branches: [Branch(condition: condition, body: body())])
	}

	/// Appends an `else if` branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `else if` branch.
	///   - body: The expression result of this branch.
	/// - Returns: A new `if` expression with the branch appended.
	public func elseIf(
		_ condition: ExpressionDescriptor,
		body: @autoclosure () -> ExpressionDescriptor,
	) -> Self {
		let branch = Branch(condition: condition, body: body())
		return Self(branches: branches + CollectionOfOne(branch))
	}

	/// Appends the terminal `else` branch.
	///
	/// - Parameter body: A result builder closure producing the statements executed when no branch condition holds.
	/// - Returns: An ``IfElseStatementDescriptor`` containing the existing branches and the `else` body.
	public func `else`(body: @autoclosure () -> ExpressionDescriptor) -> IfElseExpressionDescriptor {
		IfElseExpressionDescriptor(
			branches: branches,
			elseBody: body(),
		)
	}
}

public extension ExpressionDescriptor {
	/// Creates an `if` expression.
	///
	/// The result is an ``IfExpressionDescriptor`` rather than a ``ExpressionDescriptor`` so that
	/// `elseIf(_:body:)` and `else(body:)` can be chained.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	static func `if`(
		_ condition: ExpressionDescriptor,
		_ body: @autoclosure () -> ExpressionDescriptor,
	) -> IfExpressionDescriptor {
		IfExpressionDescriptor(condition, body: body())
	}
}

extension ArrayBuilder<ExpressionDescriptor> {
	public static func buildExpression(_ expression: IfExpressionDescriptor) -> Result {
		[.`if`(expression)]
	}
}

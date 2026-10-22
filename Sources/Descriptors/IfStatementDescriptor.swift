//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An `if` statement with its `else if` branches.
public struct IfStatementDescriptor: Sendable {
	/// A single conditional branch of an `if` statement.
	public struct Branch: Sendable {
		/// The condition that must hold for the branch to execute.
		public let condition: ExpressionDescriptor

		/// The statements executed when the condition holds.
		public let body: CodeBlockDescriptor

		/// Creates a conditional branch.
		///
		/// - Parameters:
		///   - condition: The condition that must hold for the branch to execute.
		///   - body: The statements executed when the condition holds.
		public init(condition: ExpressionDescriptor, body: CodeBlockDescriptor) {
			self.condition = condition
			self.body = body
		}
	}

	/// The `if` branch followed by any `else if` branches, in source order.
	public let branches: [Branch]

	/// Creates an `if` statement from its branches.
	///
	/// - Parameter branches: The `if` branch followed by any `else if` branches. Must not be empty.
	public init(branches: [Branch]) {
		precondition(!branches.isEmpty, "An if statement requires at least one branch.")
		self.branches = branches
	}

	/// Creates an `if` statement with a single branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: The statements executed when the condition holds.
	public init(
		_ condition: ExpressionDescriptor,
		body: CodeBlockDescriptor
	) {
		self.init(branches: [Branch(condition: condition, body: body)])
	}

	/// Creates an `if` statement with a single branch built with a result builder.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	public init(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder body: () -> [StatementDescriptor],
	) {
		self.init(condition, body: CodeBlockDescriptor(body))
	}

	/// Appends an `else if` branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `else if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	/// - Returns: A new `if` statement with the branch appended.
	public func elseIf(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder body: () -> [StatementDescriptor],
	) -> Self {
		let branch = Branch(condition: condition, body: CodeBlockDescriptor(body))
		return Self(branches: branches + CollectionOfOne(branch))
	}

	/// Appends the terminal `else` branch.
	///
	/// - Parameter body: A result builder closure producing the statements executed when no branch condition holds.
	/// - Returns: An ``IfElseStatementDescriptor`` containing the existing branches and the `else` body.
	public func `else`(
		@CodeBlockBuilder body: () -> [StatementDescriptor],
	) -> IfElseStatementDescriptor {
		IfElseStatementDescriptor(
			branches: branches,
			elseBody: CodeBlockDescriptor(body),
		)
	}
}

public extension ConditionalStatementDescriptor {
	/// Creates an `if` statement.
	///
	/// The result is an ``IfStatementDescriptor`` rather than a ``StatementDescriptor`` so that
	/// `elseIf(_:body:)` and `else(body:)` can be chained.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	static func `if`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder body: () -> [StatementDescriptor],
	) -> IfStatementDescriptor {
		IfStatementDescriptor(condition, body: body)
	}
}

extension ArrayBuilder<ConditionalStatementDescriptor> {
	public static func buildExpression(_ expression: IfStatementDescriptor) -> Result {
		[.if(expression)]
	}
}

public extension StatementDescriptor {
	/// Creates an `if` statement.
	///
	/// The result is an ``IfStatementDescriptor`` rather than a ``StatementDescriptor`` so that
	/// `elseIf(_:body:)` and `else(body:)` can be chained.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	static func `if`(
		_ condition: ExpressionDescriptor,
		@CodeBlockBuilder body: () -> [StatementDescriptor],
	) -> IfStatementDescriptor {
		IfStatementDescriptor(condition, body: body)
	}
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: IfStatementDescriptor) -> Result {
		[.conditional(.if(expression))]
	}
}
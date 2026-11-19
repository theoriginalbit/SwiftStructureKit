//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An `if` statement with its `else if` branches.
public struct TopLevelCompilerConditionalIfDescriptor: Sendable {
	/// A single conditional branch of an `if` statement.
	public struct Branch: Sendable {
		/// The condition that must hold for the branch to execute.
		public let condition: String

		/// The statements executed when the condition holds.
		public let body: [TopLevelDeclarationDescriptor]

		/// Creates a conditional branch.
		///
		/// - Parameters:
		///   - condition: The condition that must hold for the branch to execute.
		///   - body: The statements executed when the condition holds.
		public init(condition: String, body: [TopLevelDeclarationDescriptor]) {
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
		_ condition: String,
		body: [TopLevelDeclarationDescriptor]
	) {
		self.init(branches: [Branch(condition: condition, body: body)])
	}

	/// Creates an `if` statement with a single branch built with a result builder.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	public init(
		_ condition: String,
		@TopLevelDeclarationBuilder body: () -> [TopLevelDeclarationDescriptor],
	) {
		self.init(condition, body: body())
	}

	/// Appends an `else if` branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `else if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	/// - Returns: A new `if` statement with the branch appended.
	public func elseIf(
		_ condition: String,
		@TopLevelDeclarationBuilder body: () -> [TopLevelDeclarationDescriptor],
	) -> Self {
		let branch = Branch(condition: condition, body: body())
		return Self(branches: branches + CollectionOfOne(branch))
	}

	/// Appends the terminal `else` branch.
	///
	/// - Parameter body: A result builder closure producing the statements executed when no branch condition holds.
	/// - Returns: An ``IfElseStatementDescriptor`` containing the existing branches and the `else` body.
	public func `else`(
		@TopLevelDeclarationBuilder body: () -> [TopLevelDeclarationDescriptor],
	) -> TopLevelCompilerConditionalIfElseDescriptor {
		TopLevelCompilerConditionalIfElseDescriptor(
			branches: branches,
			elseBody: body(),
		)
	}
}

public extension TopLevelDeclarationDescriptor {
	/// Creates an `if` statement.
	///
	/// The result is an ``IfStatementDescriptor`` rather than a ``StatementDescriptor`` so that
	/// `elseIf(_:body:)` and `else(body:)` can be chained.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	static func `if`(
		_ condition: String,
		@TopLevelDeclarationBuilder body: () -> [TopLevelDeclarationDescriptor],
	) -> TopLevelCompilerConditionalIfDescriptor {
		TopLevelCompilerConditionalIfDescriptor(condition, body: body)
	}
}

public extension TopLevelCompilerConditionalDescriptor {
	/// Creates an `if` statement.
	///
	/// The result is an ``IfStatementDescriptor`` rather than a ``StatementDescriptor`` so that
	/// `elseIf(_:body:)` and `else(body:)` can be chained.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	static func `if`(
		_ condition: String,
		@TopLevelDeclarationBuilder body: () -> [TopLevelDeclarationDescriptor],
	) -> TopLevelCompilerConditionalIfDescriptor {
		TopLevelCompilerConditionalIfDescriptor(condition, body: body)
	}
}

extension ArrayBuilder<TopLevelCompilerConditionalDescriptor> {
	public static func buildExpression(_ expression: TopLevelCompilerConditionalIfDescriptor) -> Result {
		[.if(expression)]
	}
}

extension ArrayBuilder<TopLevelCompilerControlDescriptor> {
	public static func buildExpression(_ expression: TopLevelCompilerConditionalIfDescriptor) -> Result {
		[.conditional(.if(expression))]
	}
}

extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	public static func buildExpression(_ expression: TopLevelCompilerConditionalIfDescriptor) -> Result {
		[.compilerControl(.conditional(.if(expression)))]
	}
}

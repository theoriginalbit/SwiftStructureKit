//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An `if` statement with its `else if` branches and terminal `else` branch.
public struct TopLevelCompilerConditionalIfElseDescriptor: Sendable {
	/// The `if` branch followed by any `else if` branches, in source order.
	public let branches: [TopLevelCompilerConditionalIfDescriptor.Branch]

	/// The statements executed when no branch condition holds.
	public let elseBody: [TopLevelDeclarationDescriptor]

	/// Creates an `if` statement with a terminal `else` branch.
	///
	/// - Parameters:
	///   - branches: The `if` branch followed by any `else if` branches. Must not be empty.
	///   - elseBody: The statements executed when no branch condition holds.
	public init(branches: [TopLevelCompilerConditionalIfDescriptor.Branch], elseBody: [TopLevelDeclarationDescriptor]) {
		precondition(!branches.isEmpty, "An if statement requires at least one branch.")
		self.branches = branches
		self.elseBody = elseBody
	}
}

public extension TopLevelCompilerConditionalDescriptor {
	/// Creates an `if` statement with an `else` branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	///   - elseBody: A result builder closure producing the statements executed when the condition does not hold.
	static func `if`(
		_ condition: String,
		@TopLevelDeclarationBuilder _ body: () -> [TopLevelDeclarationDescriptor],
		@TopLevelDeclarationBuilder `else` elseBody: () -> [TopLevelDeclarationDescriptor],
	) -> Self {
		.ifElse(TopLevelCompilerConditionalIfElseDescriptor(
			branches: [
				TopLevelCompilerConditionalIfDescriptor.Branch(
					condition: condition,
					body: body(),
				),
			],
			elseBody: elseBody(),
		))
	}
}

public extension TopLevelCompilerControlDescriptor {
	/// Creates an `if` statement with an `else` branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	///   - elseBody: A result builder closure producing the statements executed when the condition does not hold.
	static func `if`(
		_ condition: String,
		@TopLevelDeclarationBuilder _ body: () -> [TopLevelDeclarationDescriptor],
		@TopLevelDeclarationBuilder `else` elseBody: () -> [TopLevelDeclarationDescriptor],
	) -> Self {
		.conditional(.if(condition, body, else: elseBody))
	}
}

public extension TopLevelDeclarationDescriptor {
	/// Creates an `if` statement with an `else` branch.
	///
	/// - Parameters:
	///   - condition: The condition of the `if` branch.
	///   - body: A result builder closure producing the statements executed when the condition holds.
	///   - elseBody: A result builder closure producing the statements executed when the condition does not hold.
	static func `if`(
		_ condition: String,
		@TopLevelDeclarationBuilder _ body: () -> [TopLevelDeclarationDescriptor],
		@TopLevelDeclarationBuilder `else` elseBody: () -> [TopLevelDeclarationDescriptor],
	) -> Self {
		.compilerControl(.conditional(.if(condition, body, else: elseBody)))
	}
}

extension ArrayBuilder<TopLevelCompilerControlDescriptor> {
	public static func buildExpression(_ expression: TopLevelCompilerConditionalIfElseDescriptor) -> Result {
		[.conditional(.ifElse(expression))]
	}
}

extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	public static func buildExpression(_ expression: TopLevelCompilerConditionalIfElseDescriptor) -> Result {
		[.compilerControl(.conditional(.ifElse(expression)))]
	}
}

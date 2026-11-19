//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A conditional compilation statement, with or without a terminal `#else` branch.
public enum TopLevelCompilerConditionalDescriptor: Sendable {
	/// An `#if` statement with zero or more `#elseif` branches and no terminal `#else`.
	///
	/// The associated descriptor stores the conditional branches in source order.
	///
	/// - Parameter descriptor: The `#if` statement and its optional `#elseif` branches.
	case `if`(TopLevelCompilerConditionalIfDescriptor)

	/// An `#if` statement with zero or more `#elseif` branches and a terminal `#else`.
	///
	/// The associated descriptor stores the conditional branches in source order, followed by the
	/// body rendered when none of their conditions hold.
	///
	/// - Parameter descriptor: The `#if` statement, its optional `#elseif` branches, and its
	///   terminal `#else` body.
	case ifElse(TopLevelCompilerConditionalIfElseDescriptor)
}

extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	public static func buildExpression(_ expression: TopLevelCompilerConditionalDescriptor) -> Result {
		[.compilerControl(.conditional(expression))]
	}
}

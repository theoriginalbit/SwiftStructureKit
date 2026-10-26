//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A compiler-control construct that can appear in a Swift source file.
///
/// Use this descriptor to represent either a diagnostic directive or a conditional
/// compilation statement.
public enum CompilerControlDescriptor: Sendable {
	/// A compiler diagnostic directive that emits a `#warning` or `#error`.
	///
	/// - Parameter descriptor: The diagnostic directive to render.
	case directive(DiagnosticDirectiveDescriptor)

	/// A conditional compilation statement beginning with `#if`.
	///
	/// - Parameter descriptor: The conditional statement and its branches.
	case conditional(CompilerConditionalStatementDescriptor)
}

/// A conditional compilation statement, with or without a terminal `#else` branch.
public enum CompilerConditionalStatementDescriptor: Sendable {
	/// An `#if` statement with zero or more `#elseif` branches and no terminal `#else`.
	///
	/// The associated descriptor stores the conditional branches in source order.
	///
	/// - Parameter descriptor: The `#if` statement and its optional `#elseif` branches.
	case `if`(IfStatementDescriptor)

	/// An `#if` statement with zero or more `#elseif` branches and a terminal `#else`.
	///
	/// The associated descriptor stores the conditional branches in source order, followed by the
	/// body rendered when none of their conditions hold.
	///
	/// - Parameter descriptor: The `#if` statement, its optional `#elseif` branches, and its
	///   terminal `#else` body.
	case ifElse(IfElseStatementDescriptor)
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: CompilerControlDescriptor) -> Result {
		[.compilerControl(expression)]
	}
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: CompilerConditionalStatementDescriptor) -> Result {
		[.compilerControl(.conditional(expression))]
	}
}
//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A keyword expression, optionally followed by an expression.
public enum UnaryKeywordDescriptor: Sendable {
	/// Returns from the current function or closure.
	///
	/// - Parameter expression: The value to return, or `nil` for a bare `return`.
	case `return`(ExpressionDescriptor?)

	/// Evaluates a throwing expression.
	///
	/// - Parameters:
	///   - hasPostfixQuestionMark: Whether to use optional `try?` rather than `try`.
	///   - expression: The expression to evaluate.
	case `try`(hasPostfixQuestionMark: Bool, ExpressionDescriptor)

	/// Awaits the result of an asynchronous expression.
	///
	/// - Parameter expression: The asynchronous expression to evaluate.
	case `await`(ExpressionDescriptor)

	/// Throws an error from the current function or closure.
	///
	/// - Parameter expression: The error expression to throw.
	case `throw`(ExpressionDescriptor)

	/// Continues with the next iteration of the current loop.
	case `continue`

	/// Exits the current loop or switch statement.
	case `break`
}

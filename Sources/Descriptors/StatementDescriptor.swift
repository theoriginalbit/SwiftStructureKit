//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for Swift statements.
public enum StatementDescriptor: Sendable {
	/// A stored or computed property declaration.
	case property(PropertyDescriptor)

	/// A variable or constant declaration.
	case declaration(DeclarationStatementDescriptor)

	/// An assignment to a target expression.
	case assignment(AssignmentStatementDescriptor)

	/// An expression evaluated as a statement.
	case expression(ExpressionDescriptor)

	/// Not truely a statement, but allows for simple addition to a ``CodeBlockDescriptor``
	case comment(InlineCommentDescriptor)

	/// A `#warning` or `#error` compiler diagnostic directive.
	case diagnostic(DiagnosticDirectiveDescriptor)

	/// A statement that places a keyword before an expression.
	case unaryKeyword(UnaryKeywordDescriptor)

	/// An `if` statement with zero or more `else if` branches.
	case `if`(IfStatementDescriptor)

	/// An `if` statement with an `else` branch.
	case ifElse(IfElseStatementDescriptor)

	/// A `guard` statement and its continuation.
	case `guard`(GuardStatementDescriptor)
}

public extension StatementDescriptor {
	/// Creates a `return` statement with an optional return expression.
	///
	/// - Parameter expression: The optional expression to return.
	static func `return`(_ expression: ExpressionDescriptor? = nil) -> Self {
		.unaryKeyword(.return(expression))
	}

	/// Creates a `try` statement with an expression and specifies if it needs `?`.
	///
	/// - Parameters:
	///   - hasPostfixQuestionMark: Whether this should be `try?`.
	///	  - expression: The expression try.
	static func `try`(hasPostfixQuestionMark: Bool = false, _ expression: ExpressionDescriptor) -> Self {
		.unaryKeyword(.try(hasPostfixQuestionMark: hasPostfixQuestionMark, expression))
	}

	/// Creates an `await` statement with an expression.
	///
	/// - Parameter expression: The expression to await.
	static func `await`(_ expression: ExpressionDescriptor) -> Self {
		.unaryKeyword(.await(expression))
	}

	/// Creates a `throw` statement with an expression.
	///
	/// - Parameter expression: The expression to throw.
	static func `throw`(_ expression: ExpressionDescriptor) -> Self {
		.unaryKeyword(.throw(expression))
	}
}

extension ArrayBuilder<StatementDescriptor> {
	/// Allows an ``ExpressionDescriptor`` to be used directly inside a code block builder, wrapping it in ``StatementDescriptor/expression(_:)``.
	///
	/// - Parameter expression: The expression to evaluate as a statement.
	public static func buildExpression(_ expression: ExpressionDescriptor) -> Result {
		[.expression(expression)]
	}
}

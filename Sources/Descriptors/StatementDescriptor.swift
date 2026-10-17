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

	/// A return statement with an optional return expression.
	case `return`(ReturnStatementDescriptor)

	/// An `if` statement with zero or more `else if` branches.
	case `if`(IfStatementDescriptor)

	/// An `if` statement with an `else` branch.
	case ifElse(IfElseStatementDescriptor)

	/// A `guard` statement and its continuation.
	case `guard`(GuardStatementDescriptor)
}

public extension StatementDescriptor {
	/// Creates a return statement with an optional return expression.
	///
	/// - Parameter expression: The optional expression to return.
	static func `return`(_ expression: ExpressionDescriptor? = nil) -> Self {
		.return(ReturnStatementDescriptor(expression))
	}
}

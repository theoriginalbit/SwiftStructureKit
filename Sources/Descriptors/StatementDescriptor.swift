//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for Swift statements.
public enum StatementDescriptor: Sendable {
	/// An assignment statement, declaring a variable or constant.
	case assignment(AssignmentStatementDescriptor)

	/// Not truely a statement, but allows for simple addition to a ``CodeBlockDescriptor``
	case comment(InlineCommentDescriptor)

	case diagnostic(DiagnosticDirectiveDescriptor)

	/// A return statement with an optional return expression.
	case `return`(ExpressionDescriptor? = nil)
}

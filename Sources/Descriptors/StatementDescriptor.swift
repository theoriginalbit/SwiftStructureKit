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

	/// A compiler control directive, such as a diagnostic directive or conditional compilation block.
	case compilerControl(CompilerControlDescriptor)

	/// A statement that controls the flow of code, e.g. `return` or `continue`.
	case controlFlow(ControlFlowDescriptor)

	/// An `if`, `if`/`else`, or `guard` statement.
	case conditional(ConditionalStatementDescriptor)

	/// A statement prefixed with a label.
	case labeled(LabeledStatementDescriptor)

	/// A `do` statement with a `catch` body.
	case `do`(DoStatementDescriptor)
}

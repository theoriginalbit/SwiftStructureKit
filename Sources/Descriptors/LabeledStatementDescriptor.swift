//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A statement prefixed with a label, such as `outer: if condition { ... }`.
public struct LabeledStatementDescriptor: Sendable {
	/// A statement that Swift permits a label on.
	///
	/// Swift only allows labels on loops, `if`, `switch`, and `do` statements.
	public enum Statement: Sendable {
		/// An `if` statement with zero or more `else if` branches and no terminal `else` branch.
		///
		/// The associated descriptor stores the branches in source order.
		case `if`(IfStatementDescriptor)

		/// An `if` statement with zero or more `else if` branches and a terminal `else` branch.
		///
		/// The associated descriptor stores the conditional branches in source order and the body
		/// executed when none of their conditions hold.
		case ifElse(IfElseStatementDescriptor)
	}

	/// The label for the statement.
	public let label: String

	/// The statement the label is attached to.
	public let statement: Statement

	/// A labeled statement.
	///
	/// - Parameters:
	///   - label: The label for the statement.
	///   - statement: The statement the label is attached to.
	public init(label: String, statement: Statement) {
		self.label = label
		self.statement = statement
	}
}

public extension StatementDescriptor {
	/// Creates a labeled statement from a supported statement descriptor.
	///
	/// - Parameters:
	///   - label: The label to attach to the statement.
	///   - statement: The labeled `if`, `if`/`else`, or `do` statement.
	/// - Returns: A labeled statement descriptor.
	static func labeled(_ label: String, _ statement: LabeledStatementDescriptor.Statement) -> Self {
		.labeled(LabeledStatementDescriptor(label: label, statement: statement))
	}

	/// Creates a labeled statement from an `if` statement.
	///
	/// - Parameters:
	///   - label: The label to attach to the statement.
	///   - statement: The `if` statement to label.
	/// - Returns: A labeled statement descriptor containing the `if` statement.
	static func labeled(_ label: String, _ statement: IfStatementDescriptor) -> Self {
		.labeled(LabeledStatementDescriptor(label: label, statement: .if(statement)))
	}

	/// Creates a labeled statement from an `if`/`else` statement.
	///
	/// - Parameters:
	///   - label: The label to attach to the statement.
	///   - statement: The `if`/`else` statement to label.
	/// - Returns: A labeled statement descriptor containing the `if`/`else` statement.
	static func labeled(_ label: String, _ statement: IfElseStatementDescriptor) -> Self {
		.labeled(LabeledStatementDescriptor(label: label, statement: .ifElse(statement)))
	}
}

public extension IfStatementDescriptor {
	/// Attaches a label to this `if` statement.
	///
	/// - Parameter label: The label to attach.
	func labeled(_ label: String) -> LabeledStatementDescriptor {
		LabeledStatementDescriptor(label: label, statement: .if(self))
	}
}

public extension IfElseStatementDescriptor {
	/// Attaches a label to this `if`/`else` statement.
	///
	/// - Parameter label: The label to attach.
	func labeled(_ label: String) -> LabeledStatementDescriptor {
		LabeledStatementDescriptor(label: label, statement: .ifElse(self))
	}
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: LabeledStatementDescriptor) -> Result {
		[.labeled(expression)]
	}
}

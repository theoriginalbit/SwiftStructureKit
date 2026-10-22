//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// Describes a Swift control-flow statement such as `return`, `throw`, `break`, `continue`, or `fallthrough`.
public enum ControlFlowDescriptor: Sendable {
	/// A `return` statement with an optional return expression.
	case `return`(ExpressionDescriptor?)

	/// A `throw` statement with an expression.
	case `throw`(ExpressionDescriptor)

	/// A `continue` statement.
	case `continue`

	/// A `break` statement.
	case `break`

	/// A `fallthrough` statement.
	case `fallthrough`
}

public extension ControlFlowDescriptor {
	/// Creates a `return` statement.
	static var `return`: Self {
		.return(nil)
	}
}

public extension StatementDescriptor {
	/// A `return` statement with an optional return expression.
	///
	/// - Parameter expression: The optional expression to return.
	static func `return`(_ expression: ExpressionDescriptor? = nil) -> Self {
		.controlFlow(.return(expression))
	}

	/// A `return` statement.
	static var `return`: Self {
		.controlFlow(.return)
	}

	/// A `throw` statement with an expression.
	///
	/// - Parameter expression: The expression to throw.
	static func `throw`(_ expression: ExpressionDescriptor) -> Self {
		.controlFlow(.throw(expression))
	}

	/// A `continue` statement.
	static var `continue`: Self {
		.controlFlow(.continue)
	}

	/// A `break` statement.
	static var `break`: Self {
		.controlFlow(.break)
	}

	/// A `fallthrough` statement.
	static var `fallthrough`: Self {
		.controlFlow(.fallthrough)
	}
}

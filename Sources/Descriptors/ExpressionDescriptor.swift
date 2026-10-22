//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// Describes a Swift expression that can be rendered as source code.
///
///	## Where is if without an else?
///
/// Unlike ``StatementDescriptor`` the plain `if(_:)` case is defined but marked unavailable as it would
/// result in invalid Swift source.
///
/// Instead use ``ifElse(_:)`` to create `if`/`else` expressions and `if`/`else if`/`else` chains.
/// There is also the ``if(_:_:)`` convenience to begin the chain with result builder syntax. The chains will
/// always end in an ``IfElseExpressionDescriptor`` compatible with ``ifElse(_:)``.
public indirect enum ExpressionDescriptor: Sendable {
	/// A literal expression.
	case literal(LiteralDescriptor)

	/// A source expression rendered without modification.
	case raw(String)

	/// A function call.
	case functionCall(FunctionCallDescriptor)

	/// A member access expression.
	///
	/// For example: `foo.bar` or `.bar`.
	case memberAccess(MemberAccessDescriptor)

	/// A type identifier.
	case identifier(TypeIdentifier)

	/// A tuple expression.
	case tuple([ExpressionDescriptor])

	/// An `if` expression without an `else` branch.
	///
	/// This case is unavailable because Swift requires `if` expressions to have
	/// an `else` branch. Use ``ifElse(_:)`` for a conditional expression.
	@available(*, unavailable, message: "If must have an unconditional 'else' to be used as an expression")
	case `if`(IfExpressionDescriptor)

	/// An `if`/`else` expression, including `if`/`else if`/`else` chains.
	///
	/// For example:
	///
	/// ```swift
	/// let value = if isPositive {
	///     1
	/// } else {
	///     0
	/// }
	/// ```
	///
	/// or:
	///
	/// ```swift
	/// let value = if isPositive {
	///     1
	/// } else if isMultipleOf2 {
	///     0
	/// } else {
	///     -1
	/// }
	/// ```
	///
	///
	/// Use ``StatementDescriptor`` when you want an `if` statement rather than
	/// an expression.
	case ifElse(IfElseExpressionDescriptor)
}

public extension ExpressionDescriptor {
	/// A member access expression.
	///
	/// For example: `foo.bar` or `.bar`.
	static func memberAccess(_ left: ExpressionDescriptor?, _ right: String) -> Self {
		.memberAccess(MemberAccessDescriptor(left, right))
	}

	/// A member access expression.
	///
	/// For example: `foo.bar` or `.bar`.
	static func memberAccess(_ left: String, _ right: String) -> Self {
		.memberAccess(MemberAccessDescriptor(.identifier(left), right))
	}

	/// An identifier expression created from a dotted string, such as `"self.value"`.
	///
	/// - Parameter value: The dotted identifier string.
	static func identifier(_ value: String) -> Self {
		.identifier(TypeIdentifier(value))
	}

	/// A tuple expression.
	static func tuple(@ArrayBuilder<ExpressionDescriptor> _ values: () -> [ExpressionDescriptor]) -> Self {
		.tuple(values())
	}
}

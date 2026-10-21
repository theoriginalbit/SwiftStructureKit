//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for Swift expressions.
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

	case `if`(IfExpressionDescriptor)

	case ifElse(IfElseExpressionDescriptor)
}

public extension ExpressionDescriptor {
	/// A function call with an identifier callee and optional arguments.
	///
	/// - Parameters:
	///   - calledExpression: The identifier of the function being called.
	///   - arguments: The arguments passed to the call.
	static func functionCall(_ calledExpression: ExpressionDescriptor, _ arguments: ArgumentsList = ArgumentsList()) -> Self {
		.functionCall(FunctionCallDescriptor(
			calledExpression: calledExpression,
			arguments: arguments,
		))
	}

	/// A function call with an identifier callee and arguments built with a result builder.
	///
	/// - Parameters:
	///   - calledExpression: The identifier of the function being called.
	///   - arguments: A builder closure producing the arguments passed to the call.
	static func functionCall(_ calledExpression: ExpressionDescriptor, @ArrayBuilder<Argument> _ arguments: () -> [Argument]) -> Self {
		.functionCall(FunctionCallDescriptor(
			calledExpression: calledExpression,
			arguments: ArgumentsList(arguments())
		))
	}

	/// A function call with an identifier callee and optional arguments.
	///
	/// - Parameters:
	///   - calledIdentifier: The identifier of the function being called.
	///   - arguments: The arguments passed to the call.
	static func functionCall(_ calledIdentifier: TypeIdentifier, _ arguments: ArgumentsList = ArgumentsList()) -> Self {
		.functionCall(FunctionCallDescriptor(
			calledExpression: .identifier(calledIdentifier),
			arguments: arguments,
		))
	}

	/// A function call with an identifier callee and arguments built with a result builder.
	///
	/// - Parameters:
	///   - calledIdentifier: The identifier of the function being called.
	///   - arguments: A builder closure producing the arguments passed to the call.
	static func functionCall(_ calledIdentifier: TypeIdentifier, @ArrayBuilder<Argument> _ arguments: () -> [Argument]) -> Self {
		.functionCall(FunctionCallDescriptor(
			calledExpression: .identifier(calledIdentifier),
			arguments: ArgumentsList(arguments())
		))
	}

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

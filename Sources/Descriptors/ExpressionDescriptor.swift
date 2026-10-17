//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for Swift expressions.
public indirect enum ExpressionDescriptor: Sendable {
	/// A literal expression.
	case literal(LiteralDescriptor)

	/// A source expression rendered without modification.
	case raw(String)

	/// A function call with an expression callee and optional arguments.
	case functionCall(ExpressionDescriptor, ArgumentsList = ArgumentsList())

	/// A type identifier.
	case identifier(TypeIdentifier)
}

public extension ExpressionDescriptor {
	/// A function call with an identifier callee and optional arguments.
	///
	/// - Parameters:
	///   - callee: The identifier of the function being called.
	///   - arguments: The arguments passed to the call.
	static func functionCall(_ callee: TypeIdentifier, _ arguments: ArgumentsList = ArgumentsList()) -> Self {
		.functionCall(.identifier(callee), arguments)
	}

	/// A function call with an identifier callee and arguments built with a result builder.
	///
	/// - Parameters:
	///   - callee: The identifier of the function being called.
	///   - arguments: A builder closure producing the arguments passed to the call.
	static func functionCall(_ callee: TypeIdentifier, @ArrayBuilder<Argument> _ arguments: () -> [Argument]) -> Self {
		.functionCall(.identifier(callee), ArgumentsList(arguments()))
	}

	/// An identifier expression created from a dotted string, such as `"self.value"`.
	///
	/// - Parameter value: The dotted identifier string.
	static func identifier(_ value: String) -> Self {
		.identifier(TypeIdentifier(value))
	}
}

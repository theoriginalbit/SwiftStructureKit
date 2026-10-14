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

	/// A function call with an expression callee and optional arguments.
	static func functionCall(_ callee: TypeIdentifier, _ arguments: ArgumentsList = ArgumentsList()) -> Self {
		.functionCall(.identifier(callee), arguments)
	}

	/// A function call with an expression callee and optional arguments.
	static func functionCall(_ callee: TypeIdentifier, @ArrayBuilder<Argument> _ arguments: () -> [Argument]) -> Self {
		.functionCall(.identifier(callee), ArgumentsList(arguments()))
	}

	/// A type identifier.
	static func identifier(_ value: String) -> Self {
		.identifier(TypeIdentifier(value))
	}
}

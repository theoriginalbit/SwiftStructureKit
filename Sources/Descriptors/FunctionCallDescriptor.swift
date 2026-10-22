//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A description of a function call.
public struct FunctionCallDescriptor: Sendable {
	/// The expression that returns the function to be called.
	public let calledExpression: ExpressionDescriptor

	/// The arguments to be passed to the function.
	public let arguments: ArgumentsList

	/// Creates a new function call description.
	///
	/// - Parameters:
	///   - calledExpression: An expression that returns the function to be called.
	///   - arguments: Arguments to be passed to the function.
	init(
		calledExpression: ExpressionDescriptor,
		arguments: ArgumentsList = [],
	) {
		self.calledExpression = calledExpression
		self.arguments = arguments
	}

	/// Creates a new function call description.
	///
	/// - Parameters:
	///   - calledExpression: An expression that returns the function to be called.
	///   - arguments: Arguments to be passed to the function.
	init(
		calledExpression: ExpressionDescriptor,
		arguments: [ExpressionDescriptor],
	) {
		self.init(
			calledExpression: calledExpression,
			arguments: ArgumentsList {
				for argument in arguments {
					Argument(value: argument)
				}
			}
		)
	}
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
}

public extension StatementDescriptor {
	/// A function call with an identifier callee and optional arguments.
	///
	/// - Parameters:
	///   - calledExpression: The identifier of the function being called.
	///   - arguments: The arguments passed to the call.
	static func functionCall(_ calledExpression: ExpressionDescriptor, _ arguments: ArgumentsList = ArgumentsList()) -> Self {
		.expression(.functionCall(FunctionCallDescriptor(
			calledExpression: calledExpression,
			arguments: arguments,
		)))
	}

	/// A function call with an identifier callee and arguments built with a result builder.
	///
	/// - Parameters:
	///   - calledExpression: The identifier of the function being called.
	///   - arguments: A builder closure producing the arguments passed to the call.
	static func functionCall(_ calledExpression: ExpressionDescriptor, @ArrayBuilder<Argument> _ arguments: () -> [Argument]) -> Self {
		.expression(.functionCall(FunctionCallDescriptor(
			calledExpression: calledExpression,
			arguments: ArgumentsList(arguments())
		)))
	}

	/// A function call with an identifier callee and optional arguments.
	///
	/// - Parameters:
	///   - calledIdentifier: The identifier of the function being called.
	///   - arguments: The arguments passed to the call.
	static func functionCall(_ calledIdentifier: TypeIdentifier, _ arguments: ArgumentsList = ArgumentsList()) -> Self {
		.expression(.functionCall(FunctionCallDescriptor(
			calledExpression: .identifier(calledIdentifier),
			arguments: arguments,
		)))
	}

	/// A function call with an identifier callee and arguments built with a result builder.
	///
	/// - Parameters:
	///   - calledIdentifier: The identifier of the function being called.
	///   - arguments: A builder closure producing the arguments passed to the call.
	static func functionCall(_ calledIdentifier: TypeIdentifier, @ArrayBuilder<Argument> _ arguments: () -> [Argument]) -> Self {
		.expression(.functionCall(FunctionCallDescriptor(
			calledExpression: .identifier(calledIdentifier),
			arguments: ArgumentsList(arguments())
		)))
	}
}
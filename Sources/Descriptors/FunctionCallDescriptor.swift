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

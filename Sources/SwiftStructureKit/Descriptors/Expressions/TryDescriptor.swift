//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A throwing expression prefixed with `try`, optionally using `try?` or `try!`.
public struct TryDescriptor: Sendable {
	/// The form of the `try` expression.
	public enum Variant: Sendable {
		/// Uses `try?`.
		case optional

		/// Uses `try!`.
		case forced
	}

	/// The `try` variant to render, or `nil` for plain `try`.
	public let variant: Variant?

	/// The expression evaluated by `try`.
	public let expression: ExpressionDescriptor

	/// Creates a descriptor for a throwing expression.
	///
	/// - Parameters:
	///   - variant: The `try` variant, or `nil` for plain `try`.
	///   - expression: The expression to evaluate.
	public init(_ variant: Variant?, _ expression: ExpressionDescriptor) {
		self.variant = variant
		self.expression = expression
	}
}

public extension ExpressionDescriptor {
	/// Evaluates a throwing expression using the specified `try` variant.
	///
	/// - Parameters:
	///   - variant: Whether to use `try?` or `try!`; pass `nil` for plain `try`.
	///   - expression: The expression to evaluate.
	static func `try`(_ variant: TryDescriptor.Variant? ,_ expression: ExpressionDescriptor) -> Self {
		.try(TryDescriptor(variant, expression))
	}

	/// Evaluates a throwing expression using plain `try`.
	///
	/// - Parameters:
	///   - expression: The expression to evaluate.
	static func `try`(_ expression: ExpressionDescriptor) -> Self {
		.try(TryDescriptor(nil, expression))
	}

	/// Evaluates a throwing expression using `try?`.
	///
	/// - Parameters:
	///   - expression: The expression to evaluate.
	static func optionalTry(_ expression: ExpressionDescriptor) -> Self {
		.try(TryDescriptor(.optional, expression))
	}

	/// Evaluates a throwing expression using `try!`.
	///
	/// - Parameters:
	///   - expression: The expression to evaluate.
	static func forcedTry(_ expression: ExpressionDescriptor) -> Self {
		.try(TryDescriptor(.forced, expression))
	}
}

public extension StatementDescriptor {
	/// Creates a statement that evaluates a throwing expression using the specified `try` variant.
	///
	/// - Parameters:
	///   - variant: Whether to use `try?` or `try!`; pass `nil` for plain `try`.
	///   - expression: The expression to evaluate.
	static func `try`(_ variant: TryDescriptor.Variant? ,_ expression: ExpressionDescriptor) -> Self {
		.expression(.try(variant, expression))
	}

	/// Creates a statement that evaluates a throwing expression using plain `try`.
	///
	/// - Parameters:
	///   - expression: The expression to evaluate.
	static func `try`(_ expression: ExpressionDescriptor) -> Self {
		.expression(.try(expression))
	}

	/// Creates a statement that evaluates a throwing expression using `try?`.
	///
	/// - Parameters:
	///   - expression: The expression to evaluate.
	static func optionalTry(_ expression: ExpressionDescriptor) -> Self {
		.expression(.optionalTry(expression))
	}

	/// Creates a statement that evaluates a throwing expression using `try!`.
	///
	/// - Parameters:
	///   - expression: The expression to evaluate.
	static func forcedTry(_ expression: ExpressionDescriptor) -> Self {
		.expression(.forcedTry(expression))
	}
}

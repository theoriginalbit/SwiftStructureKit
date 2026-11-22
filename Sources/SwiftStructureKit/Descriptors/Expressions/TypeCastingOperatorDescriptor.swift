//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A type-casting expression such as `is type`, `as type`, `as? type`, or `as! type`.
public struct TypeCastingOperatorDescriptor: Sendable {
	/// The form of the type-casting expression.
	public enum Variant: Sendable {
		/// Uses `as?`.
		case optionally

		/// Uses `as!`.
		case forced
	}

	/// The kind of type-casting expression.
	public enum Kind: Sendable {
		/// Type-casting as a boolean result.
		case `is`

		/// Type-casting to a type infallible, conditionally, or forced.
		case `as`(Variant?)
	}

	/// The expression to type-cast.
	public let expression: ExpressionDescriptor

	/// Whether type-casting with `is` or `as`.
	public let kind: Kind

	/// The type evaluated by `is` or `as`.
	public let type: TypeReference

	/// Creates a descriptor for a type-casting expression.
	///
	/// - Parameters:
	///   - expression: The expression to type-cast.
	///   - kind: Whether type-casting with `is` or `as`.
	///   - type: The type evaluated.
	public init(_ expression: ExpressionDescriptor, _ kind: Kind, _ type: TypeReference) {
		self.expression = expression
		self.kind = kind
		self.type = type
	}
}

public extension TypeCastingOperatorDescriptor {
	/// Creates a descriptor for a type-casting expression.
	///
	/// - Parameters:
	///   - expression: The expression to type-cast.
	///   - type: The type evaluated.
	static func `is`(_ expression: ExpressionDescriptor, _ type: TypeReference) -> Self {
		.init(expression, .is, type)
	}

	/// Creates a descriptor for a type-casting expression.
	///
	/// - Parameters:
	///   - expression: The expression to type-cast.
	///   - type: The type evaluated.
	///   - variant: Whether it is infallible (`as`), conditional (`as?`), or forced (`as!`).
	static func `as`(_ expression: ExpressionDescriptor, _ type: TypeReference, _ variant: Variant? = nil) -> Self {
		.init(expression, .as(variant), type)
	}
}

public extension TypeCastingOperatorDescriptor.Kind {
	/// Type-casting to a type infallibly (`as`).
	static var `as`: Self {
		.as(nil)
	}
}

public extension ExpressionDescriptor {
	/// Creates a descriptor for a type-casting this expression.
	///
	/// - Parameters:
	///   - type: The type evaluated.
	func `is`(_ type: TypeReference) -> ExpressionDescriptor {
		.typeCast(.is(self, type))
	}

	/// Creates a descriptor for a type-casting expression.
	///
	/// - Parameters:
	///   - type: The type evaluated.
	///   - variant: Whether it is infallible (`as`), conditional (`as?`), or forced (`as!`).
	func `as`(_ type: TypeReference, _ variant: TypeCastingOperatorDescriptor.Variant? = nil) -> Self {
		.typeCast(.as(self, type, variant))
	}
}

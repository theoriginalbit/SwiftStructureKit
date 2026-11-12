//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A generic parameter and its optional inline type constraint.
///
/// Use this descriptor to represent a parameter such as `T` or `T: Equatable & Sendable`.
public struct GenericParameterDescriptor: Equatable, Sendable {
	/// The identifier of the generic parameter.
	public let identifier: TypeIdentifier

	/// The optional type constraint applied to the parameter.
	public let constraint: TypeComposition?

	/// Creates a generic parameter descriptor.
	///
	/// - Parameters:
	///   - identifier: The parameter's type identifier.
	///   - constraint: The optional composition of types that constrain the parameter.
	public init(_ identifier: TypeIdentifier, constraint: TypeComposition? = nil) {
		self.identifier = identifier
		self.constraint = constraint
	}

	/// Creates a generic parameter descriptor from a string identifier.
	///
	/// - Parameters:
	///   - identifier: The parameter's identifier, such as `"T"`.
	///   - constraint: The optional composition of types that constrain the parameter.
	public init(_ identifier: String, constraint: TypeComposition? = nil) {
		self.init(TypeIdentifier(identifier), constraint: constraint)
	}

	/// Creates a generic parameter descriptor with one or more type constraints.
	///
	/// - Parameters:
	///   - identifier: The parameter's identifier, such as `"T"`.
	///   - constraint: The types that constrain the parameter. Multiple types are combined with `&`.
	public init(_ identifier: String, constraint: TypeReference...) {
		self.init(TypeIdentifier(identifier), constraint: TypeComposition(constraint))
	}
}

extension GenericParameterDescriptor: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		self.init(value)
	}
}

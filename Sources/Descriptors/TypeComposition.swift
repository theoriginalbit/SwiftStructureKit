//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import OrderedCollections

/// A qualified Swift type name, represented as independently sanitized components.
public struct TypeIdentifier: Hashable, Sendable, ExpressibleByStringLiteral {
	/// The components making up the qualified type name.
	public let components: [String]

	public init(_ identifier: String) {
		self.components = identifier.split(separator: ".", omittingEmptySubsequences: false).map(String.init)
	}

	public init(components: [String]) {
		self.components = components
	}

	public init(stringLiteral value: String) {
		self.init(value)
	}
}

/// A composition of types joined by `&`.
public struct TypeComposition: Hashable, Sendable {
	public let types: OrderedSet<TypeReference>

	public init(_ type: TypeReference) {
		self.types = [type]
	}

	public init(_ types: OrderedSet<TypeReference>) {
		self.types = types
	}

	public init(_ types: [TypeReference]) {
		self.types = OrderedSet(types)
	}
}

/// A generic parameter and its optional inline conformance constraint.
public struct GenericParameterDescriptor: Hashable, Sendable, ExpressibleByStringLiteral {
	public let identifier: TypeIdentifier
	public let constraint: TypeComposition?

	public init(_ identifier: TypeIdentifier, constraint: TypeComposition? = nil) {
		self.identifier = identifier
		self.constraint = constraint
	}

	public init(_ identifier: String, constraint: TypeComposition? = nil) {
		self.init(TypeIdentifier(identifier), constraint: constraint)
	}

	public init(stringLiteral value: String) {
		self.init(value)
	}
}

/// A generic `where` requirement constraining a type to a composition.
public struct TypeConstraintDescriptor: Hashable, Sendable {
	public let type: TypeIdentifier
	public let constraint: TypeComposition

	public init(_ type: TypeIdentifier, constraint: TypeComposition) {
		self.type = type
		self.constraint = constraint
	}

	public init(_ type: TypeIdentifier, conformsTo constraint: TypeReference) {
		self.init(type, constraint: TypeComposition(constraint))
	}

	public init(_ type: TypeIdentifier, conformsTo constraint: TypeComposition) {
		self.init(type, constraint: constraint)
	}

	public init(_ type: TypeIdentifier, conformsTo constraints: OrderedSet<TypeReference>) {
		self.init(type, constraint: TypeComposition(constraints))
	}

}

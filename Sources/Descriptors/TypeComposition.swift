//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A qualified Swift type name, represented as independently sanitized components.
public struct TypeIdentifier: Hashable, Sendable, ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
	/// The components making up the qualified type name.
	public let components: [String]

	public init(_ identifier: String) {
		self.components = identifier.split(separator: ".", omittingEmptySubsequences: false).map(String.init)
	}

	public init(_ components: [String]) {
		self.components = components
	}

	public init(stringLiteral value: String) {
		self.init(value)
	}

	public init(arrayLiteral elements: String...) {
		self.components = elements
	}
}

/// A composition of types joined by `&`.
public struct TypeComposition: Hashable, Sendable, ExpressibleByArrayLiteral {
	public let types: [TypeReference]

	public init(_ type: TypeReference) {
		self.types = [type]
	}

	public init(_ types: [TypeReference]) {
		self.types = types
	}

	public init(arrayLiteral elements: TypeReference...) {
		self.init(elements)
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

	public init(_ identifier: String, constraint: TypeReference...) {
		self.init(TypeIdentifier(identifier), constraint: TypeComposition(constraint))
	}

	public init(stringLiteral value: String) {
		self.init(value)
	}
}

/// A generic `where` requirement constraining a type to a composition.
public struct TypeConstraintDescriptor: Hashable, Sendable {
	/// A constraint applied to the constraint.
	public enum Kind: Hashable, Sendable {
		/// The constraint represents conforming `Foo: Bar`.
		case conformsTo(TypeComposition)

		/// The constraint represents same-type `Foo == Bar`.
		case sameType(TypeComposition)
	}

	public let type: TypeIdentifier
	public let kind: Kind

	public init(_ type: TypeIdentifier, conformsTo constraint: TypeReference) {
		self.type = type
		self.kind = .conformsTo(TypeComposition(constraint))
	}

	public init(_ type: TypeIdentifier, conformsTo constraint: TypeComposition) {
		self.type = type
		self.kind = .conformsTo(constraint)
	}

	public init(_ type: TypeIdentifier, conformsTo constraints: [TypeReference]) {
		self.type = type
		self.kind = .conformsTo(TypeComposition(constraints))
	}

	public init(_ type: TypeIdentifier, sameType constraint: TypeReference) {
		self.type = type
		self.kind = .sameType(TypeComposition(constraint))
	}

	public init(_ type: TypeIdentifier, sameType constraint: TypeComposition) {
		self.type = type
		self.kind = .sameType(constraint)
	}

	public init(_ type: TypeIdentifier, sameType constraints: [TypeReference]) {
		self.type = type
		self.kind = .sameType(TypeComposition(constraints))
	}
}

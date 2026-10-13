//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import OrderedCollections

/// A reference to a type representation in Swift.
public indirect enum TypeReference: Hashable, Sendable {
	/// Creates a type reference from a source identifier.
	case identifier(String)

	/// A type reference representing an array of the specified element type.
	case array(TypeReference)

	/// A type reference representing a dictionary of the specified key and value types.
	case dictionary(key: TypeReference, value: TypeReference)

	/// A type reference representing a type that is optional.
	case optional(TypeReference)

	/// An existential any type reference.
	case any(TypeReference)

	/// An existential some type reference, or opaque return type.
	case some(TypeReference)

	/// Creates a tuple type from its elements.
	case tuple([TupleElementDescriptor])

	/// A type reference representing a closure.
	case closure(parameters: OrderedSet<TypeReference>, returns: TypeReference)

	/// A type reference representing a generic parameter and it's constraints, if any.
	case genericParameter(name: String, constraints: OrderedSet<TypeReference>)
}

/// A component of a tuple type.
public struct TupleElementDescriptor: Hashable, Sendable {
	/// The optional label of the tuple element.
	public let label: String?

	/// The type of the tuple element.
	public let type: TypeReference

	/// Creates a tuple element.
	public init(label: String? = nil, type: TypeReference) {
		self.label = label
		self.type = type
	}
}

// MARK: - Construction convenience

public extension TypeReference {
	/// Creates a tuple type from its element types.
	static func tuple(_ types: Self...) -> Self {
		.tuple(types.map { TupleElementDescriptor(type: $0) })
	}

	/// Creates a tuple type from its element types.
	static func tuple(@ArrayBuilder<TupleElementDescriptor> _ types: () -> [TupleElementDescriptor]) -> Self {
		.tuple(types())
	}

	/// Creates a generic parameter with optional type constraints.
	static func genericParameter(_ name: String, constraints: OrderedSet<Self> = []) -> Self {
		.genericParameter(name: name, constraints: constraints)
	}
}

extension ArrayBuilder where T == TupleElementDescriptor {
	public static func buildExpression(_ expression: TypeReference) -> Result {
		[T(type: expression)]
	}
}

// MARK: Built-in types

public extension TypeReference {
	/// A type reference to `String`.
	static var string: Self {
		.identifier("String")
	}

	/// A type reference to `Int`.
	static var int: Self {
		.identifier("Int")
	}

	/// A type reference to `Double`.
	static var double: Self {
		.identifier("Double")
	}

	/// A type reference to `Bool`.
	static var bool: Self {
		.identifier("Bool")
	}

	/// A type reference to `Sendable`.
	static var sendable: Self {
		.identifier("Sendable")
	}

	/// A type reference to `Equatable`.
	static var equatable: Self {
		.identifier("Equatable")
	}
}

// MARK: Foundation types

public extension TypeReference {
	/// A type reference to `Data`.
	static var data: Self {
		.identifier("Data")
	}

	/// A type reference to `Date`.
	static var date: Self {
		.identifier("Date")
	}
}

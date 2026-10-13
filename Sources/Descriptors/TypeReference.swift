//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A reference to a type representation in Swift.
public struct TypeReference: Hashable, Sendable {
	/// The Swift source spelling of the referenced type.
	public let sourceIdentifier: String

	init(sourceIdentifier: String) {
		self.sourceIdentifier = sourceIdentifier
	}
}

// MARK: Built-in types

public extension TypeReference {
	/// A type reference to `String`.
	static var string: Self {
		Self(sourceIdentifier: "String")
	}

	/// A type reference to `Int`.
	static var int: Self {
		Self(sourceIdentifier: "Int")
	}

	/// A type reference to `Double`.
	static var double: Self {
		Self(sourceIdentifier: "Double")
	}

	/// A type reference to `Bool`.
	static var bool: Self {
		Self(sourceIdentifier: "Bool")
	}

	/// A type reference representing an array of the specified element type.
	///
	/// - Parameter element: The type of each array element.
	/// - Returns: A reference to `Array<Element>`.
	static func array(_ element: Self) -> Self {
		Self(sourceIdentifier: "Array<\(element.sourceIdentifier)>")
	}

	/// A type reference representing a dictionary of the specified key and value types.
	///
	/// - Parameters:
	///   - key: The dictionary key type.
	///   - value: The dictionary value type.
	/// - Returns: A reference to `Dictionary<Key, Value>`.
	static func dictionary(key: Self, value: Self) -> Self {
		Self(sourceIdentifier: "Dictionary<\(key.sourceIdentifier),\(value.sourceIdentifier)>")
	}

	/// A type reference representing a type that is optional.
	///
	/// - Parameter value: The wrapped type.
	/// - Returns: A reference to `Optional<Wrapped>`.
	static func optional(_ value: Self) -> Self {
		Self(sourceIdentifier: "Optional<\(value.sourceIdentifier)>")
	}

	/// Creates a type reference from a source identifier.
	///
	/// - Parameter value: The type's source spelling.
	/// - Returns: A reference that renders the identifier verbatim.
	static func identifier(_ value: String) -> Self {
		Self(sourceIdentifier: value)
	}

	/// A type reference to `Sendable`.
	static var sendable: Self {
		Self(sourceIdentifier: "Sendable")
	}

	/// A type reference to `Equatable`.
	static var equatable: Self {
		Self(sourceIdentifier: "Equatable")
	}
}

// MARK: Foundation types

public extension TypeReference {
	/// A type reference to `Data`.
	static var data: Self {
		Self(sourceIdentifier: "Data")
	}

	/// A type reference to `Date`.
	static var date: Self {
		Self(sourceIdentifier: "Date")
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A reference to a type representation in Swift.
public struct TypeReference: Hashable, Sendable {
	public let sourceIdentifier: String

	init(sourceIdentifier: String) {
		self.sourceIdentifier = sourceIdentifier
	}
}

// MARK: Built-in types

public extension TypeReference {
	static var string: Self {
		Self(sourceIdentifier: "String")
	}

	static var int: Self {
		Self(sourceIdentifier: "Int")
	}

	static var double: Self {
		Self(sourceIdentifier: "Double")
	}

	static var bool: Self {
		Self(sourceIdentifier: "Bool")
	}

	/// A type reference representing an array of the specified element type.
	static func array(_ element: Self) -> Self {
		Self(sourceIdentifier: "Array<\(element.sourceIdentifier)>")
	}

	/// A type reference representing a dictionary of the specified key and value types.
	static func dictionary(key: Self, value: Self) -> Self {
		Self(sourceIdentifier: "Dictionary<\(key.sourceIdentifier),\(value.sourceIdentifier)>")
	}

	/// A type reference representing a type that is optional.
	static func optional(_ value: Self) -> Self {
		Self(sourceIdentifier: "Optional<\(value.sourceIdentifier)>")
	}

	static func identifier(_ value: String) -> Self {
		Self(sourceIdentifier: value)
	}

	static var sendable: Self {
		Self(sourceIdentifier: "Sendable")
	}

	static var equatable: Self {
		Self(sourceIdentifier: "Equatable")
	}
}

// MARK: Foundation types

public extension TypeReference {
	static var data: Self {
		Self(sourceIdentifier: "Data")
	}

	static var date: Self {
		Self(sourceIdentifier: "Date")
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A reference to a type representation in Swift.
public indirect enum TypeReference: Sendable {
	/// A type reference for the specified type name.
	case type(String)

	/// A type reference representing an array of the specified element type.
	case array(Self)

	/// A type reference representing a dictionary of the specified key and value types.
	case dictionary(key: Self, value: Self)

	/// A type reference representing a type that is optional.
	case optional(Self)
}

extension TypeReference: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self = .type(value)
	}
}

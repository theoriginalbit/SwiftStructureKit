//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A protocol representing Swift types that can be used as raw values for enumeration cases.
public protocol RawValueEnumValueType: Sendable {
	/// The type reference corresponding to the raw value type.
	static var typeReference: TypeReference { get }
}

extension String: RawValueEnumValueType {
	/// The type reference for `String`.
	public static var typeReference: TypeReference { .string }
}

extension Int: RawValueEnumValueType {
	/// The type reference for `Int`.
	public static var typeReference: TypeReference { .int }
}

extension Double: RawValueEnumValueType {
	/// The type reference for `Double`.
	public static var typeReference: TypeReference { .double }
}

extension Bool: RawValueEnumValueType {
	/// The type reference for `Bool`.
	public static var typeReference: TypeReference { .bool }
}

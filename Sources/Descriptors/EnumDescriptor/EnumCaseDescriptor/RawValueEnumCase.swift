//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An enum kind representing enumerations that use raw values of a specific type.
public struct RawValueEnumMode<TypeRef: RawValueEnumValueType>: EnumMode {
	/// A strongly-typed literal wrapper for raw enum values.
	public struct RawValueLiteral: Sendable {
		/// The underlying literal descriptor representing the raw value.
		public let literal: LiteralDescriptor
	}
}

/// A convenience type alias for an enum case descriptor within a raw-value enumeration.
public typealias RawValueEnumCase<RawValueType: RawValueEnumValueType> = EnumCaseDescriptor<RawValueEnumMode<RawValueType>>

// MARK: - Literal Conveniences

extension RawValueEnumMode.RawValueLiteral where TypeRef == String {
	/// Creates a raw value literal from a string value.
	///
	/// - Parameter value: The string value of the literal.
	/// - Returns: A raw value literal instance wrapping the string.
	public static func string(_ value: String) -> Self {
		Self(literal: .string(value))
	}
}

extension RawValueEnumMode.RawValueLiteral where TypeRef == Int {
	/// Creates a raw value literal from an integer value.
	///
	/// - Parameter value: The integer value of the literal.
	/// - Returns: A raw value literal instance wrapping the integer.
	public static func integer(_ value: Int) -> Self {
		Self(literal: .integer(value))
	}
}

extension RawValueEnumMode.RawValueLiteral where TypeRef == Double {
	/// Creates a raw value literal from a floating-point value.
	///
	/// - Parameter value: The double value of the literal.
	/// - Returns: A raw value literal instance wrapping the double.
	public static func double(_ value: Double) -> Self {
		Self(literal: .double(value))
	}
}

extension RawValueEnumMode.RawValueLiteral where TypeRef == Bool {
	/// Creates a raw value literal from a boolean value.
	///
	/// - Parameter value: The boolean value of the literal.
	/// - Returns: A raw value literal instance wrapping the boolean.
	public static func boolean(_ value: Bool) -> Self {
		Self(literal: .boolean(value))
	}
}

// MARK: - Enum Case Construction Conveniences

extension EnumCaseDescriptor {
	/// Creates a raw-value enum case with an explicit raw value and optional documentation comment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - rawValue: The strongly-typed raw value literal for the case.
	///   - comment: An optional documentation comment for the case.
	public init<RawValueType: RawValueEnumValueType>(
		_ name: String,
		rawValue: RawValueEnumMode<RawValueType>.RawValueLiteral,
		comment: DocCommentDescriptor? = nil
	) where Mode == RawValueEnumMode<RawValueType> {
		self.name = name
		self.rawValue = rawValue.literal
		self.associatedValues = []
		self.comment = comment
	}

	/// Creates a string raw-value enum case without an explicit raw value assignment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - comment: An optional documentation comment for the case.
	public init(
		_ name: String,
		comment: DocCommentDescriptor? = nil
	) where Mode == RawValueEnumMode<String> {
		self.name = name
		self.rawValue = nil
		self.associatedValues = []
		self.comment = comment
	}
}

extension ArrayBuilder where T == RawValueEnumCase<String> {
	/// Represents an enum case without explicit raw values within an
	/// enum that declares raw values.
	public static func buildExpression(_ statement: String) -> Result {
		[EnumCaseDescriptor(statement)]
	}
}

// MARK: - Enum Raw Types

/// A protocol representing Swift types that can be used as raw values for enumeration cases.
public protocol RawValueEnumValueType {
	/// The type reference corresponding to the raw value type.
	static var typeReference: TypeReference { get }
}

extension String: RawValueEnumValueType {
	public static var typeReference: TypeReference { .string }
}

extension Int: RawValueEnumValueType {
	public static var typeReference: TypeReference { .int }
}

extension Double: RawValueEnumValueType {
	public static var typeReference: TypeReference { .double }
}

extension Bool: RawValueEnumValueType {
	public static var typeReference: TypeReference { .bool }
}

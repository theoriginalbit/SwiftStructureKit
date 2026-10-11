//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

// MARK: - Construction Conveniences

/// An enum kind representing enumerations that use raw values of a specific type.
@dynamicMemberLookup
public struct RawValueEnumDescriptor<TypeRef: RawValueEnumValueType>: Sendable {
	/// A strongly-typed literal wrapper for raw enum values.
	public struct RawValueLiteral: Sendable {
		/// The underlying literal descriptor representing the raw value.
		public let literal: LiteralDescriptor
	}

	let descriptor: AnyEnumDescriptor

	public subscript<T>(dynamicMember keyPath: KeyPath<AnyEnumDescriptor, T>) -> T {
		descriptor[keyPath: keyPath]
	}

	/// Creates an enum with raw values descriptor.
	///
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		@ArrayBuilder<RawValueEnumCaseDescriptor<TypeRef>> cases: () -> [RawValueEnumCaseDescriptor<TypeRef>],
		@TypeMembersBuilder members: () -> TypeMembersBuilder.Result = { [] },
	) {
		// make sure the first conformance is the raw value type
		var conformances = conformances
		if conformances.first != TypeRef.typeReference {
			conformances.insert(TypeRef.typeReference, at: 0)
		}
		descriptor = AnyEnumDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			genericTypes: genericTypes,
			conformances: conformances,
			cases: cases().map(\.descriptor),
			members: members()
		)
	}
}

// MARK: - Supporting Types

/// A protocol representing Swift types that can be used as raw values for enumeration cases.
public protocol RawValueEnumValueType: Sendable {
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

/// A descriptor representing a enum case declaration that has a raw value.
public struct RawValueEnumCaseDescriptor<TypeRef: RawValueEnumValueType>: Sendable {
	let descriptor: AnyEnumCaseDescriptor

	public subscript<T>(dynamicMember keyPath: KeyPath<AnyEnumCaseDescriptor, T>) -> T {
		descriptor[keyPath: keyPath]
	}

	/// Creates a raw-value enum case with an explicit raw value and optional documentation comment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - rawValue: The strongly-typed raw value literal for the case.
	///   - comment: An optional documentation comment for the case.
	public init(
		_ name: String,
		rawValue: RawValueEnumDescriptor<TypeRef>.RawValueLiteral,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: rawValue.literal,
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == String {
	/// Creates a string raw-value enum case without an explicit raw value assignment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - comment: An optional documentation comment for the case.
	init(
		_ name: String,
		comment: DocCommentDescriptor? = nil,
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: nil, // by specifying `nil` it means it won't get rendered and use the name
			associatedValues: [],
			comment: comment,
		)
	}
}

// MARK: - Construction Conveniences

public extension ArrayBuilder where T == RawValueEnumCaseDescriptor<String> {
	static func buildExpression(_ statement: String) -> [T] {
		[T(statement)]
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == String {
	init(
		_ name: String,
		rawValue: TypeRef,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: .string(rawValue),
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == Int {
	init(
		_ name: String,
		rawValue: TypeRef,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: .integer(rawValue),
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == Double {
	init(
		_ name: String,
		rawValue: TypeRef,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: .double(rawValue),
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == Bool {
	init(
		_ name: String,
		rawValue: TypeRef,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: .boolean(rawValue),
			associatedValues: [],
			comment: comment,
		)
	}
}

// MARK: - Literal Conveniences

public extension RawValueEnumDescriptor.RawValueLiteral where TypeRef == String {
	/// Creates a raw value literal from a string value.
	///
	/// - Parameter value: The string value of the literal.
	/// - Returns: A raw value literal instance wrapping the string.
	static func string(_ value: String) -> Self {
		Self(literal: .string(value))
	}
}

public extension RawValueEnumDescriptor.RawValueLiteral where TypeRef == Int {
	/// Creates a raw value literal from an integer value.
	///
	/// - Parameter value: The integer value of the literal.
	/// - Returns: A raw value literal instance wrapping the integer.
	static func integer(_ value: Int) -> Self {
		Self(literal: .integer(value))
	}
}

public extension RawValueEnumDescriptor.RawValueLiteral where TypeRef == Double {
	/// Creates a raw value literal from a floating-point value.
	///
	/// - Parameter value: The double value of the literal.
	/// - Returns: A raw value literal instance wrapping the double.
	static func double(_ value: Double) -> Self {
		Self(literal: .double(value))
	}
}

public extension RawValueEnumDescriptor.RawValueLiteral where TypeRef == Bool {
	/// Creates a raw value literal from a boolean value.
	///
	/// - Parameter value: The boolean value of the literal.
	/// - Returns: A raw value literal instance wrapping the boolean.
	static func boolean(_ value: Bool) -> Self {
		Self(literal: .boolean(value))
	}
}

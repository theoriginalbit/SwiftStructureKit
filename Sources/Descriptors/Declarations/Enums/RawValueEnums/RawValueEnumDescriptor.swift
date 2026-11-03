//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

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
	///   - attributes: Attributes applied to the enum.
	///   - genericParameters: The generic parameters associated with the enum.
	///   - genericRequirements: The generic `where` requirements associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@ArrayBuilder<RawValueEnumCaseDescriptor<TypeRef>> cases: () -> [RawValueEnumCaseDescriptor<TypeRef>],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
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
			attributes: attributes,
			genericParameters: genericParameters,
			genericRequirements: genericRequirements,
			conformances: conformances,
			cases: cases().map(\.descriptor),
			members: members()
		)
	}
}

// MARK: - Construction Conveniences

public extension ArrayBuilder<DeclarationDescriptor> {
	static func buildExpression(_ expression: RawValueEnumDescriptor<some RawValueEnumValueType>) -> [T] {
		[.enum(expression.descriptor)]
	}
}

public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	static func buildExpression(_ expression: RawValueEnumDescriptor<some RawValueEnumValueType>) -> [T] {
		[.member(.enum(expression.descriptor))]
	}
}

public extension DeclarationDescriptor {
	/// Creates an enum with raw values descriptor.
	///
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - attributes: Attributes applied to the enum.
	///   - genericParameters: The generic parameters associated with the enum.
	///   - genericRequirements: The generic `where` requirements associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	@_disfavoredOverload static func `enum`<RawValueType: RawValueEnumValueType>(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@ArrayBuilder<RawValueEnumCaseDescriptor<RawValueType>> rawValueCases cases: () -> [RawValueEnumCaseDescriptor<RawValueType>],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) -> Self {
		Self.enum(RawValueEnumDescriptor<RawValueType>(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericParameters: genericParameters,
			genericRequirements: genericRequirements,
			conformances: conformances,
			cases: cases,
			members: members,
		).descriptor)
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

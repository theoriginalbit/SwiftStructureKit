//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A marker protocol representing the classification of an enumeration (e.g. plain, raw-value, or associated-value).
public protocol EnumMode: Sendable {
	/// The optional raw value type reference associated with the enum kind.
	static var rawValueType: TypeReference? { get }
}

public extension EnumMode {
	static var rawValueType: TypeReference? { nil }
}

/// A convenience type alias for an enum descriptor representing a plain enumeration with no raw values or associated values.
public typealias PlainEnum = EnumDescriptor<PlainEnumMode>

/// A convenience type alias for an enum descriptor representing an enumeration with raw values.
public typealias RawValueEnum<RawValue: RawValueEnumValueType> = EnumDescriptor<RawValueEnumMode<RawValue>>

/// A convenience type alias for an enum descriptor representing an enumeration with associated values.
public typealias AssociatedValueEnum = EnumDescriptor<AssociatedValueEnumMode>

/// A descriptor representing a Swift enumeration declaration.
public struct EnumDescriptor<EnumCaseMode: EnumMode>: Sendable {
	/// A result builder alias for constructing enum cases.
	public typealias EnumCaseBuilder = ArrayBuilder<EnumCaseDescriptor<EnumCaseMode>>

	/// The documentation comment attached to the enum definition, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the enum, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The name identifier of the enum.
	public let identifier: String

	/// The generic type parameters declared for the enum.
	public let genericTypes: [TypeReference]

	/// The type and protocol conformances of the enum.
	public let conformances: [TypeReference]

	/// The cases of the enum.
	public let cases: EnumCaseBuilder.Result

	/// The member declarations contained within the enum.
	public let members: TypeMembersBuilder.Result

	/// Creates an enum descriptor with cases and member declarations built using result builders.
	///
	/// - Parameters:
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - identifier: The name of the enum.
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	public init(
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		identifier: String,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		@EnumCaseBuilder cases: () -> EnumCaseBuilder.Result,
		@TypeMembersBuilder members: () -> TypeMembersBuilder.Result,
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.identifier = identifier
		self.genericTypes = genericTypes
		self.conformances = conformances
		self.cases = cases()
		self.members = members()
	}

	/// Creates an enum descriptor with cases built using a result builder and no additional members.
	///
	/// - Parameters:
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - identifier: The name of the enum.
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	public init(
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		identifier: String,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		@EnumCaseBuilder cases: () -> EnumCaseBuilder.Result,
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.identifier = identifier
		self.genericTypes = genericTypes
		self.conformances = conformances
		self.cases = cases()
		self.members = []
	}

	/// Creates an enum descriptor with member declarations built using a result builder and no cases.
	///
	/// This style of enum is often referred to by developers as a "namespace".
	///
	/// - Parameters:
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - identifier: The name of the enum.
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	@_disfavoredOverload
	public init(
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		identifier: String,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		@TypeMembersBuilder members: () -> TypeMembersBuilder.Result
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.identifier = identifier
		self.genericTypes = genericTypes
		self.conformances = conformances
		self.cases = []
		self.members = members()
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import OrderedCollections

/// A descriptor representing a Swift structure declaration.
public struct StructDescriptor: Sendable {
	/// The documentation comment attached to the struct definition, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the struct, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The attributes applied to the struct.
	public let attributes: [AttributeDescriptor]

	/// The name identifier of the struct.
	public let identifier: String

	/// The generic type parameters declared for the struct.
	public let genericParameters: OrderedSet<GenericParameterDescriptor>

	/// The generic `where` requirements declared by the struct.
	public let genericRequirements: [TypeConstraintDescriptor]

	/// The type and protocol conformances of the struct.
	public let conformances: OrderedSet<TypeReference>

	/// The member declarations contained within the struct.
	public let members: [TypeMemberDescriptor]

	/// Creates a struct descriptor with an explicit array of member descriptors.
	init(
		_ identifier: String,
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		attributes: [AttributeDescriptor],
		genericParameters: OrderedSet<GenericParameterDescriptor>,
		genericRequirements: [TypeConstraintDescriptor],
		conformances: OrderedSet<TypeReference>,
		members: [TypeMemberDescriptor],
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.identifier = identifier
		self.genericParameters = genericParameters
		self.genericRequirements = genericRequirements
		self.conformances = conformances
		self.members = members
	}

	/// Creates a struct descriptor using a result builder to define member descriptors.
	///
	/// - Parameters:
	///   - identifier: The name of the struct.
	///   - comment: An optional documentation comment for the struct.
	///   - accessModifier: An optional access level modifier for the struct.
	///   - attributes: Attributes applied to the struct.
	///   - genericParameters: The generic parameters associated with the struct.
	///   - genericRequirements: The generic `where` requirements associated with the struct.
	///   - conformances: The types or protocols the struct conforms to.
	///   - members: A result builder closure producing the member descriptors contained within the struct.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: OrderedSet<GenericParameterDescriptor> = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: OrderedSet<TypeReference> = [],
		@TypeMembersBuilder members: () -> [TypeMemberDescriptor],
	) {
		self.init(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericParameters: genericParameters,
			genericRequirements: genericRequirements,
			conformances: conformances,
			members: members()
		)
	}
}

public extension TypeMemberDescriptor {
	/// Creates a member descriptor for a struct.
	///
	/// - Parameters:
	///   - identifier: The name of the struct.
	///   - comment: An optional documentation comment for the struct.
	///   - accessModifier: An optional access level modifier for the struct.
	///   - attributes: Attributes applied to the struct.
	///   - genericParameters: The generic parameters associated with the struct.
	///   - genericRequirements: The generic `where` requirements associated with the struct.
	///   - conformances: The types or protocols the struct conforms to.
	///   - members: A result builder closure producing the member descriptors contained within the struct.
	static func `struct`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: OrderedSet<GenericParameterDescriptor> = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: OrderedSet<TypeReference> = [],
		@TypeMembersBuilder members: () -> [TypeMemberDescriptor],
	) -> Self {
		Self.struct(StructDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericParameters: genericParameters,
			genericRequirements: genericRequirements,
			conformances: conformances,
			members: members(),
		))
	}
}

public extension ArrayBuilder<TypeMemberDescriptor> {
	static func buildExpression(_ expression: StructDescriptor) -> [T] {
		[.struct(expression)]
	}
}

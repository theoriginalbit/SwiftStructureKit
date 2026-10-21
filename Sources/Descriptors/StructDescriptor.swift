//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

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
	public let genericParameters: [GenericParameterDescriptor]

	/// The generic `where` requirements declared by the struct.
	public let genericRequirements: [TypeConstraintDescriptor]

	/// The type and protocol conformances of the struct.
	public let conformances: [TypeReference]

	/// The member declarations contained within the struct.
	public let members: [DeclarationDescriptor]

	/// Creates a struct descriptor using a result builder to define its members.
	///
	/// - Parameters:
	///   - identifier: The name of the struct.
	///   - comment: An optional documentation comment for the struct.
	///   - accessModifier: An optional access level modifier for the struct.
	///   - attributes: The attributes applied to the struct.
	///   - genericParameters: The generic parameters associated with the struct.
	///   - genericRequirements: The generic `where` requirements declared by the struct.
	///   - conformances: The types or protocols the struct conforms to.
	///   - members: A result builder closure producing the struct's member declarations.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		members: [DeclarationDescriptor] = [],
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

	/// Creates a struct descriptor using a result builder to define its members.
	///
	/// - Parameters:
	///   - identifier: The name of the struct.
	///   - comment: An optional documentation comment for the struct.
	///   - accessModifier: An optional access level modifier for the struct.
	///   - attributes: The attributes applied to the struct.
	///   - genericParameters: The generic parameters associated with the struct.
	///   - genericRequirements: The generic `where` requirements declared by the struct.
	///   - conformances: The types or protocols the struct conforms to.
	///   - members: A result builder closure producing the struct's member declarations.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.identifier = identifier
		self.genericParameters = genericParameters
		self.genericRequirements = genericRequirements
		self.conformances = conformances
		self.members = members()
	}
}

public extension ArrayBuilder<DeclarationDescriptor> {
	static func buildExpression(_ expression: StructDescriptor) -> [T] {
		[.struct(expression)]
	}
}

public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	static func buildExpression(_ expression: StructDescriptor) -> [T] {
		[.member(.struct(expression))]
	}
}

public extension DeclarationDescriptor {
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
	///   - members: A result builder closure producing the struct's member declarations.
	static func `struct`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) -> Self {
		.struct(StructDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericParameters: genericParameters,
			genericRequirements: genericRequirements,
			conformances: conformances,
			members: members
		))
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// Type-erased representation of any enumeration declaration.
public struct AnyEnumDescriptor: Sendable {
	/// The documentation comment attached to the enum definition, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the enum, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The attributes applied to the enum.
	public let attributes: [AttributeDescriptor]

	/// The name identifier of the enum.
	public let identifier: String

	/// The generic type parameters declared for the enum.
	public let genericParameters: [GenericParameterDescriptor]

	/// The generic `where` requirements declared by the enum.
	public let genericRequirements: [TypeConstraintDescriptor]

	/// The type and protocol conformances of the enum.
	public let conformances: [TypeReference]

	/// The cases of the enum.
	public let cases: [AnyEnumCaseDescriptor]

	/// The member declarations contained within the enum.
	public let members: [DeclarationDescriptor]

	/// Creates an enum descriptor.
	///
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - genericParameters: The generic parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: The case descriptors for the enum.
	///   - members: The member descriptors contained within the enum.
	internal init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		cases: [AnyEnumCaseDescriptor] = [],
		members: [DeclarationDescriptor] = [],
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.identifier = identifier
		self.genericParameters = genericParameters
		self.genericRequirements = genericRequirements
		self.conformances = conformances
		self.cases = cases
		self.members = members
	}
}

public extension ArrayBuilder<DeclarationDescriptor> {
	static func buildExpression(_ expression: AnyEnumDescriptor) -> [T] {
		[.enum(expression)]
	}
}

public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	static func buildExpression(_ expression: AnyEnumDescriptor) -> [T] {
		[.member(.enum(expression))]
	}
}

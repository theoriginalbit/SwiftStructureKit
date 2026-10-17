//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a Swift typealias declaration.
public struct TypealiasDescriptor: Sendable {
	/// A comment applied the typealias.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the alias, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The attributes applied to the typealias.
	public let attributes: [AttributeDescriptor]

	/// The alias name.
	public let name: String

	/// The type this alias refers to.
	public let assignedType: TypeComposition

	public init(
		_ name: String,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		assignedType: TypeReference,
		comment: DocCommentDescriptor? = nil,
	) {
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.name = name
		self.assignedType = TypeComposition(assignedType)
		self.comment = comment
	}

	public init(
		_ name: String,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		assignedTypes: [TypeReference],
		comment: DocCommentDescriptor? = nil,
	) {
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.name = name
		self.assignedType = TypeComposition(assignedTypes)
		self.comment = comment
	}

	public init(
		_ name: String,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		assignedType: TypeComposition,
		comment: DocCommentDescriptor? = nil,
	) {
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.name = name
		self.assignedType = assignedType
		self.comment = comment
	}
}

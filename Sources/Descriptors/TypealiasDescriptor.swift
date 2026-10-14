//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import OrderedCollections

/// A descriptor representing a Swift typealias declaration.
public struct TypealiasDescriptor: Sendable {
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
		assignedType: TypeReference
	) {
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.name = name
		self.assignedType = TypeComposition(assignedType)
	}

	public init(
		_ name: String,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		assignedTypes: OrderedSet<TypeReference>
	) {
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.name = name
		self.assignedType = TypeComposition(assignedTypes)
	}

	public init(
		_ name: String,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		assignedType: TypeComposition
	) {
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.name = name
		self.assignedType = assignedType
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a Swift typealias declaration.
public struct TypealiasDescriptor: Sendable {
	/// The access level modifier specified for the alias, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The alias identifier.
	public let identifier: TypeReference

	/// The type this alias refers to.
	public let assignedType: TypeReference

	init(
		_ identifier: TypeReference,
		accessModifier: AccessModifierDescriptor? = nil,
		assignedType: TypeReference
	) {
		self.accessModifier = accessModifier
		self.identifier = identifier
		self.assignedType = assignedType
	}
}

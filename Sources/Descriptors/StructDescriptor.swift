//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a Swift structure declaration.
public struct StructDescriptor: Sendable {
	/// The documentation comment attached to the struct definition, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the struct, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The name identifier of the struct.
	public let identifier: String

	/// The generic type parameters declared for the struct.
	public let genericTypes: [TypeReference]

	/// The type and protocol conformances of the struct.
	public let conformances: [TypeReference]

	/// The member declarations contained within the struct.
	public let members: TypeMembersBuilder.Result

	/// Creates a struct descriptor with an explicit array of member descriptors.
	init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		members: TypeMembersBuilder.Result,
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.identifier = identifier
		self.genericTypes = genericTypes
		self.conformances = conformances
		self.members = members
	}

	/// Creates a struct descriptor using a result builder to define member descriptors.
	///
	/// - Parameters:
	///   - identifier: The name of the struct.
	///   - comment: An optional documentation comment for the struct.
	///   - accessModifier: An optional access level modifier for the struct.
	///   - genericTypes: The generic type parameters associated with the struct.
	///   - conformances: The types or protocols the struct conforms to.
	///   - members: A result builder closure producing the member descriptors contained within the struct.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		@TypeMembersBuilder members: () -> TypeMembersBuilder.Result,
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.identifier = identifier
		self.genericTypes = genericTypes
		self.conformances = conformances
		self.members = members()
	}
}

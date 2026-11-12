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

	/// The generic parameters declared by the alias (`typealias Pair<T> = (T, T)`).
	public let genericParameters: [GenericParameterDescriptor]

	/// The type this alias refers to.
	public let assignedType: TypeComposition

	/// Creates a typealias referring to a single type.
	///
	/// - Parameters:
	///   - name: The alias name.
	///   - accessModifier: An optional access level modifier for the alias.
	///   - attributes: Attributes applied to the alias.
	///   - genericParameters: The generic parameters declared by the alias.
	///   - assignedType: The type the alias refers to.
	///   - comment: An optional documentation comment for the alias.
	public init(
		_ name: String,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		assignedType: TypeReference,
		comment: DocCommentDescriptor? = nil,
	) {
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.name = name
		self.genericParameters = genericParameters
		self.assignedType = TypeComposition(assignedType)
		self.comment = comment
	}

	/// Creates a typealias referring to a composition of types (`A & B`).
	///
	/// - Parameters:
	///   - name: The alias name.
	///   - accessModifier: An optional access level modifier for the alias.
	///   - attributes: Attributes applied to the alias.
	///   - genericParameters: The generic parameters declared by the alias.
	///   - assignedTypes: The types composed by the alias.
	///   - comment: An optional documentation comment for the alias.
	public init(
		_ name: String,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		assignedTypes: [TypeReference],
		comment: DocCommentDescriptor? = nil,
	) {
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.name = name
		self.genericParameters = genericParameters
		self.assignedType = TypeComposition(assignedTypes)
		self.comment = comment
	}

	/// Creates a typealias referring to a type composition.
	///
	/// - Parameters:
	///   - name: The alias name.
	///   - accessModifier: An optional access level modifier for the alias.
	///   - attributes: Attributes applied to the alias.
	///   - genericParameters: The generic parameters declared by the alias.
	///   - assignedType: The type composition the alias refers to.
	///   - comment: An optional documentation comment for the alias.
	public init(
		_ name: String,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		assignedType: TypeComposition,
		comment: DocCommentDescriptor? = nil,
	) {
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.name = name
		self.genericParameters = genericParameters
		self.assignedType = assignedType
		self.comment = comment
	}
}

public extension ArrayBuilder<DeclarationDescriptor> {
	static func buildExpression(_ expression: TypealiasDescriptor) -> [T] {
		[.typealias(expression)]
	}
}

public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	static func buildExpression(_ expression: TypealiasDescriptor) -> [T] {
		[.member(.typealias(expression))]
	}
}

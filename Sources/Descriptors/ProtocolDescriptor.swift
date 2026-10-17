//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a Swift protocol declaration.
///
/// - Note: Primary associated types are automatically added to `genericParameters`, after explicitly supplied parameters.
public struct ProtocolDescriptor: Sendable {
	/// The documentation comment attached to the protocol definition, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the protocol, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The attributes applied to the protocol.
	public let attributes: [AttributeDescriptor]

	/// The name identifier of the protocol.
	public let identifier: String

	/// The generic type parameters declared for the protocol.
	public let genericParameters: [GenericParameterDescriptor]

	/// The generic `where` requirements declared by the protocol.
	public let genericRequirements: [TypeConstraintDescriptor]

	/// The type and protocol conformances of the protocol.
	public let conformances: [TypeReference]

	/// The member declarations contained within the protocol.
	public let members: [ProtocolMemberDescriptor]

	/// Creates a protocol descriptor using a result builder to define its members.
	///
	/// - Parameters:
	///   - identifier: The name of the protocol.
	///   - comment: An optional documentation comment for the protocol.
	///   - accessModifier: An optional access level modifier for the protocol.
	///   - genericParameters: The generic parameters associated with the protocol.
	///   - genericRequirements: The generic `where` requirements associated with the protocol.
	///   - conformances: The types or protocols the protocol inherits from.
	///   - members: A result builder closure producing the protocol's member declarations.
	init(
		_ identifier: String,
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		attributes: [AttributeDescriptor],
		genericParameters: [GenericParameterDescriptor],
		genericRequirements: [TypeConstraintDescriptor],
		conformances: [TypeReference],
		members: [ProtocolMemberDescriptor],
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.identifier = identifier
		// make sure primary associated types appear in the generics list
		let primaryAssociatedTypes = members.lazy.compactMap { member -> GenericParameterDescriptor? in
			if case let .associatedtype(descriptor) = member, descriptor.isPrimary {
				return GenericParameterDescriptor(descriptor.name)
			}

			return nil
		}
		self.genericParameters = genericParameters + primaryAssociatedTypes // let the renderer de-duplicate
		self.genericRequirements = genericRequirements
		self.conformances = conformances
		self.members = members
	}

	/// Creates a protocol descriptor using a result builder to define its members.
	///
	/// Primary associated types declared by `members` are added to `genericParameters`
	/// automatically. Explicit generic types retain their order, followed by any
	/// primary associated types not already present.
	///
	/// - Parameters:
	///   - identifier: The name of the protocol.
	///   - comment: An optional documentation comment for the protocol.
	///   - accessModifier: An optional access level modifier for the protocol.
	///   - attributes: Attributes applied to the protocol.
	///   - genericParameters: The generic parameters associated with the protocol.
	///   - genericRequirements: The generic `where` requirements associated with the protocol.
	///   - conformances: The types or protocols the protocol inherits from.
	///   - members: A result builder closure producing the protocol's member declarations.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@ProtocolMemberBuilder members: () -> [ProtocolMemberDescriptor] = { [] },
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

/// A property requirement declared by a protocol.
public struct ProtocolPropertyDescriptor: Sendable {
	/// The documentation comment attached to the protocol property definition, if any.
	public let comment: DocCommentDescriptor?

	/// The attributes applied to the property.
	public let attributes: [AttributeDescriptor]

	/// The name identifier of the protocol property.
	public let identifier: String

	/// The type reference of the protocol property.
	public let type: TypeReference

	/// The accessor specifiers for the protocol property.
	public let accessorSpecifier: ProtocolPropertyAccessorSpecifier

	/// Creates a protocol property requirement.
	///
	/// - Parameters:
	///   - comment: An optional documentation comment for the property.
	///   - attributes: Attributes applied to the property.
	///   - identifier: The name of the property.
	///   - type: The property's type.
	///   - accessorSpecifier: The required property accessors.
	public init(
		comment: DocCommentDescriptor?,
		attributes: [AttributeDescriptor] = [],
		identifier: String,
		type: TypeReference,
		accessorSpecifier: ProtocolPropertyAccessorSpecifier
	) {
		self.comment = comment
		self.attributes = attributes
		self.identifier = identifier
		self.type = type
		self.accessorSpecifier = accessorSpecifier
	}
}

/// The accessors required by a protocol property.
public enum ProtocolPropertyAccessorSpecifier: Sendable {
	/// The property must be readable.
	case get

	/// The property must be readable and settable.
	case getSet

	/// The property must be borrowable.
	case borrow

	/// The property must support mutable borrowing.
	case borrowMutate
}

/// An associated type requirement declared by a protocol.
public struct ProtocolAssociatedtypeDescriptor: Sendable {
	/// A constraint applied to an associated type.
	public enum Kind: Sendable {
		/// The associated type conforms to the specified type.
		case conformsTo(TypeComposition)

		/// The associated type is the same type as the specified type.
		case defaultType(TypeReference)
	}

	/// The associated type's name.
	public let name: String

	/// The associated type's conformance or same-type requirement, if any.
	public let kind: Kind?

	/// Whether this associated type is a primary associated type.
	public let isPrimary: Bool

	/// Creates an unconstrained associated type requirement.
	///
	/// - Parameter name: The associated type's name.
	public init(_ name: String) {
		self.name = name
		self.kind = nil
		self.isPrimary = false
	}

	/// Creates an associated type requirement constrained to conform to a type.
	///
	/// - Parameters:
	///   - name: The associated type's name.
	///   - other: The type the associated type must conform to.
	///   - isPrimary: Whether this is a primary associated type.
	public init(_ name: String, conformsTo other: TypeReference, isPrimary: Bool = false) {
		self.name = name
		self.kind = .conformsTo(TypeComposition(other))
		self.isPrimary = isPrimary
	}

	/// Creates an associated type requirement constrained to conform to a type.
	///
	/// - Parameters:
	///   - name: The associated type's identifier.
	///   - others: The types the associated type must conform to.
	///   - isPrimary: Whether this is a primary associated type.
	public init(_ name: String, conformsTo others: [TypeReference], isPrimary: Bool = false) {
		self.name = name
		self.kind = .conformsTo(TypeComposition(others))
		self.isPrimary = isPrimary
	}

	/// Creates an associated type requirement constrained to conform to a type composition.
	public init(_ name: String, conformsTo constraint: TypeComposition, isPrimary: Bool = false) {
		self.name = name
		self.kind = .conformsTo(constraint)
		self.isPrimary = isPrimary
	}

	/// Creates an associated type requirement constrained to be another type.
	///
	/// - Parameters:
	///   - name: The associated type's name.
	///   - other: The type the associated type must be identical to.
	///   - isPrimary: Whether this is a primary associated type.
	public init(_ name: String, sameTypeAs other: TypeReference, isPrimary: Bool = false) {
		self.name = name
		self.kind = .defaultType(other)
		self.isPrimary = isPrimary
	}
}

/// A typealias declaration within a protocol.
public struct ProtocolTypealiasDescriptor: Sendable {
	let descriptor: TypealiasDescriptor

	/// The alias name.
	public var name: String { descriptor.name }

	/// The generic parameters declared by the alias.
	public var genericParameters: [GenericParameterDescriptor] { descriptor.genericParameters }

	/// The type this alias refers to.
	public var assignedType: TypeComposition { descriptor.assignedType }

	/// Creates a protocol typealias referring to a single type.
	///
	/// - Parameters:
	///   - name: The alias name.
	///   - attributes: Attributes applied to the alias.
	///   - genericParameters: The generic parameters declared by the alias.
	///   - assignedType: The type the alias refers to.
	public init(
		_ name: String,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		assignedType: TypeReference,
	) {
		self.descriptor = TypealiasDescriptor(
			name,
			attributes: attributes,
			genericParameters: genericParameters,
			assignedType: assignedType
		)
	}

	/// Creates a protocol typealias referring to a composition of types (`A & B`).
	///
	/// - Parameters:
	///   - name: The alias name.
	///   - attributes: Attributes applied to the alias.
	///   - genericParameters: The generic parameters declared by the alias.
	///   - assignedTypes: The types composed by the alias.
	public init(
		_ name: String,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		assignedTypes: TypeReference...,
	) {
		self.descriptor = TypealiasDescriptor(
			name,
			attributes: attributes,
			genericParameters: genericParameters,
			assignedTypes: assignedTypes
		)
	}

	/// Creates a protocol typealias referring to a type composition.
	///
	/// - Parameters:
	///   - name: The alias name.
	///   - attributes: Attributes applied to the alias.
	///   - genericParameters: The generic parameters declared by the alias.
	///   - assignedType: The type composition the alias refers to.
	public init(
		_ name: String,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		assignedType: TypeComposition,
	) {
		self.descriptor = TypealiasDescriptor(
			name,
			attributes: attributes,
			genericParameters: genericParameters,
			assignedType: assignedType
		)
	}
}

/// A declaration that can appear as a protocol member.
public enum ProtocolMemberDescriptor: Sendable {
	/// An associated type requirement.
	case `associatedtype`(ProtocolAssociatedtypeDescriptor)

	/// A typealias declaration.
	case `typealias`(ProtocolTypealiasDescriptor)

	/// A property requirement.
	case property(ProtocolPropertyDescriptor)

	/// A function requirement.
	case function(FunctionSignatureDescriptor)
}

/// A result builder for assembling protocol member declarations.
public typealias ProtocolMemberBuilder = ArrayBuilder<ProtocolMemberDescriptor>

extension ArrayBuilder where T == ProtocolMemberDescriptor {
	public static func buildExpression(_ expression: ProtocolAssociatedtypeDescriptor) -> Result {
		[.associatedtype(expression)]
	}

	public static func buildExpression(_ expression: ProtocolPropertyDescriptor) -> Result {
		[.property(expression)]
	}

	public static func buildExpression(_ expression: FunctionSignatureDescriptor) -> Result {
		[.function(expression)]
	}
}

public extension TypeMemberDescriptor {
	/// Creates a member descriptor for a protocol.
	///
	/// - Parameters:
	///   - identifier: The name of the protocol.
	///   - comment: An optional documentation comment for the protocol.
	///   - accessModifier: An optional access level modifier for the protocol.
	///   - attributes: Attributes applied to the protocol.
	///   - genericParameters: The generic parameters associated with the protocol.
	///   - genericRequirements: The generic `where` requirements associated with the protocol.
	///   - conformances: The types or protocols the protocol inherits from.
	///   - members: A result builder closure producing the protocol's member declarations.
	static func `protocol`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@ProtocolMemberBuilder members: () -> [ProtocolMemberDescriptor] = { [] },
	) -> Self {
		.protocol(ProtocolDescriptor(
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

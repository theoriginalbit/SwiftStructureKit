//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import OrderedCollections

/// A descriptor representing a Swift protocol declaration.
///
/// - Note: Associated type members declared as primary associated types are automatically added to `genericTypes`, after explicitly supplied generic types.
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
	public let genericTypes: OrderedSet<TypeReference>

	/// The type and protocol conformances of the protocol.
	public let conformances: OrderedSet<TypeReference>

	/// The member declarations contained within the protocol.
	public let members: [ProtocolMemberDescriptor]

	/// Creates a protocol descriptor using a result builder to define its members.
	///
	/// - Parameters:
	///   - identifier: The name of the protocol.
	///   - comment: An optional documentation comment for the protocol.
	///   - accessModifier: An optional access level modifier for the protocol.
	///   - genericTypes: The generic type parameters associated with the protocol.
	///   - conformances: The types or protocols the protocol inherits from.
	///   - members: A result builder closure producing the protocol's member declarations.
	init(
		_ identifier: String,
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		attributes: [AttributeDescriptor],
		genericTypes: OrderedSet<TypeReference>,
		conformances: OrderedSet<TypeReference>,
		members: [ProtocolMemberDescriptor],
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.identifier = identifier
		// make sure primary associated types appear in the generics list
		let primaryAssociatedTypes = members.lazy.compactMap {
			if case let .associatedtype(descriptor) = $0, descriptor.isPrimary {
				return descriptor.identifier
			}
			return nil
		}
		self.genericTypes = genericTypes.union(primaryAssociatedTypes)
		self.conformances = conformances
		self.members = members
	}

	/// Creates a protocol descriptor using a result builder to define its members.
	///
	/// Primary associated types declared by `members` are added to `genericTypes`
	/// automatically. Explicit generic types retain their order, followed by any
	/// primary associated types not already present.
	///
	/// - Parameters:
	///   - identifier: The name of the protocol.
	///   - comment: An optional documentation comment for the protocol.
	///   - accessModifier: An optional access level modifier for the protocol.
	///   - attributes: Attributes applied to the protocol.
	///   - genericTypes: The generic type parameters associated with the protocol.
	///   - conformances: The types or protocols the protocol inherits from.
	///   - members: A result builder closure producing the protocol's member declarations.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericTypes: OrderedSet<TypeReference> = [],
		conformances: OrderedSet<TypeReference> = [],
		@ProtocolMemberBuilder members: () -> [ProtocolMemberDescriptor] = { [] },
	) {
		self.init(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericTypes: genericTypes,
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
		case conformsTo(OrderedSet<TypeReference>)

		/// The associated type is the same type as the specified type.
		case defaultType(TypeReference)
	}

	/// The associated type's identifier.
	public let identifier: TypeReference

	/// The associated type's conformance or same-type requirement, if any.
	public let kind: Kind?

	/// Whether this associated type is a primary associated type.
	public let isPrimary: Bool

	/// Creates an unconstrained associated type requirement.
	///
	/// - Parameter identifier: The associated type's identifier.
	public init(_ identifier: TypeReference) {
		self.identifier = identifier
		self.kind = nil
		self.isPrimary = false
	}

	/// Creates an associated type requirement constrained to conform to a type.
	///
	/// - Parameters:
	///   - identifier: The associated type's identifier.
	///   - other: The type the associated type must conform to.
	///   - isPrimary: Whether this is a primary associated type.
	public init(_ identifier: TypeReference, conformsTo other: TypeReference, isPrimary: Bool = false) {
		self.identifier = identifier
		self.kind = .conformsTo([other])
		self.isPrimary = isPrimary
	}

	/// Creates an associated type requirement constrained to conform to a type.
	///
	/// - Parameters:
	///   - identifier: The associated type's identifier.
	///   - others: The types the associated type must conform to.
	///   - isPrimary: Whether this is a primary associated type.
	public init(_ identifier: TypeReference, conformsTo others: OrderedSet<TypeReference>, isPrimary: Bool = false) {
		self.identifier = identifier
		self.kind = .conformsTo(others)
		self.isPrimary = isPrimary
	}

	/// Creates an associated type requirement constrained to be another type.
	///
	/// - Parameters:
	///   - identifier: The associated type's identifier.
	///   - other: The type the associated type must be identical to.
	///   - isPrimary: Whether this is a primary associated type.
	public init(_ identifier: TypeReference, sameTypeAs other: TypeReference, isPrimary: Bool = false) {
		self.identifier = identifier
		self.kind = .defaultType(other)
		self.isPrimary = isPrimary
	}
}

/// A typealias declaration within a protocol.
public struct ProtocolTypealiasDescriptor: Sendable {
	let descriptor: TypealiasDescriptor

	/// The alias identifier.
	public var identifier: TypeReference { descriptor.identifier }

	/// The type this alias refers to.
	public var assignedType: OrderedSet<TypeReference> { descriptor.assignedType }

	public init(
		_ identifier: TypeReference,
		attributes: [AttributeDescriptor] = [],
		assignedType: TypeReference,
	) {
		self.descriptor = TypealiasDescriptor(identifier, attributes: attributes, assignedType: assignedType)
	}

	public init(
		_ identifier: TypeReference,
		attributes: [AttributeDescriptor] = [],
		assignedTypes: OrderedSet<TypeReference>,
	) {
		self.descriptor = TypealiasDescriptor(identifier, attributes: attributes, assignedTypes: assignedTypes)
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
	///   - genericTypes: The generic type parameters associated with the protocol.
	///   - conformances: The types or protocols the protocol inherits from.
	///   - members: A result builder closure producing the protocol's member declarations.
	static func `protocol`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericTypes: OrderedSet<TypeReference> = [],
		conformances: OrderedSet<TypeReference> = [],
		@ProtocolMemberBuilder members: () -> [ProtocolMemberDescriptor] = { [] },
	) -> Self {
		.protocol(ProtocolDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericTypes: genericTypes,
			conformances: conformances,
			members: members
		))
	}
}

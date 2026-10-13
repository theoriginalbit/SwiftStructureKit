//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import Collections

public struct ProtocolDescriptor: Sendable {
	/// The documentation comment attached to the protocol definition, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the protocol, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The name identifier of the protocol.
	public let identifier: String

	/// The generic type parameters declared for the protocol.
	public let genericTypes: OrderedSet<TypeReference>

	/// The type and protocol conformances of the protocol.
	public let conformances: OrderedSet<TypeReference>

	/// The function member declarations the protocol.
	public let members: [ProtocolMemberDescriptor]

	init(
		_ identifier: String,
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		genericTypes: OrderedSet<TypeReference>,
		conformances: OrderedSet<TypeReference>,
		members: [ProtocolMemberDescriptor],
	) {
		self.comment = comment
		self.accessModifier = accessModifier
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

	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: OrderedSet<TypeReference> = [],
		conformances: OrderedSet<TypeReference> = [],
		@ProtocolMemberBuilder members: () -> [ProtocolMemberDescriptor] = { [] },
	) {
		self.init(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			genericTypes: genericTypes,
			conformances: conformances,
			members: members()
		)
	}
}

public struct ProtocolPropertyDescriptor: Sendable {
	/// The documentation comment attached to the protocol property definition, if any.
	public let comment: DocCommentDescriptor?

	/// The name identifier of the protocol property.
	public let identifier: String

	/// The type reference of the protocol property.
	public let type: TypeReference

	/// The accessor specifiers for the protocol property.
	public let accessorSpecifier: ProtocolPropertyAccessorSpecifier

	public init(
		comment: DocCommentDescriptor?,
		identifier: String,
		type: TypeReference,
		accessorSpecifier: ProtocolPropertyAccessorSpecifier
	) {
		self.comment = comment
		self.identifier = identifier
		self.type = type
		self.accessorSpecifier = accessorSpecifier
	}
}

public enum ProtocolPropertyAccessorSpecifier: Sendable {
	case get
	case getSet
	case borrow
	case borrowMutate
}

public struct ProtocolAssociatedtypeDescriptor: Sendable {
	public enum Kind: Sendable {
		case conformsTo(TypeReference)
		case sameType(TypeReference)
	}

	public let identifier: TypeReference
	public let kind: Kind?
	public let isPrimary: Bool

	public init(_ identifier: TypeReference) {
		self.identifier = identifier
		self.kind = nil
		self.isPrimary = false
	}

	public init(_ identifier: TypeReference, conformsTo other: TypeReference, isPrimary: Bool = false) {
		self.identifier = identifier
		self.kind = .conformsTo(other)
		self.isPrimary = isPrimary
	}

	public init(_ identifier: TypeReference, sameTypeAs other: TypeReference, isPrimary: Bool = false) {
		self.identifier = identifier
		self.kind = .sameType(other)
		self.isPrimary = isPrimary
	}
}

public struct ProtocolTypealiasDescriptor: Sendable {
	let descriptor: TypealiasDescriptor

	/// The alias identifier.
	public var identifier: TypeReference { descriptor.identifier }

	/// The type this alias refers to.
	public var assignedType: TypeReference { descriptor.assignedType }

	init(_ identifier: TypeReference, assignedType: TypeReference) {
		self.descriptor = TypealiasDescriptor(identifier, assignedType: assignedType)
	}
}

public enum ProtocolMemberDescriptor: Sendable {
	case `associatedtype`(ProtocolAssociatedtypeDescriptor)
	case `typealias`(ProtocolTypealiasDescriptor)
	case property(ProtocolPropertyDescriptor)
	case function(FunctionSignatureDescriptor)
}

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
	static func `protocol`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: OrderedSet<TypeReference> = [],
		conformances: OrderedSet<TypeReference> = [],
		@ProtocolMemberBuilder members: () -> [ProtocolMemberDescriptor] = { [] },
	) -> Self {
		.protocol(ProtocolDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			genericTypes: genericTypes,
			conformances: conformances,
			members: members
		))
	}
}

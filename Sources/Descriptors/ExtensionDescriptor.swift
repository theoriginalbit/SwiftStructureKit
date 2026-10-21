//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a Swift extension declaration.
///
/// This descriptor follows some basic Swift grammar rules which can be in juxtaposition to other descriptors:
///
/// - It names the type it extends as a ``TypeReference`` instead of declaring a `String` identifier.
/// - It has no generic parameter clauses; an extension cannot introduce type parameters and grammar such
///   as `extension ArrayBuilder<String>` can also be represented by generic requirements
///   `extension ArrayBuilder where T == String`.
/// - Access level modifiers and conformance lists are mutually exclusive; `public extension Foo: Bar`
///   is disallowed by the compiler as the conformance's visibility is decided by the visibility of the protocol and
///   the type. The descriptor has properties for both for rendering convenience, but the initialisers offer one or
///   the other and never both.
/// - It is only valid at the file scope and therefore is not part of ``DeclarationDescriptor``.
///
/// - Note: Extensions cannot declare stored instance properties. This descriptor does not currently prevent
///			their inclusion in ``members``.
public struct ExtensionDescriptor: Sendable {
	/// The documentation comment attached to the extension, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the extension, if any.
	///
	/// This modifier will become the default access level of the extension's members unless they
	/// explicitly declare an access level; the rendering will strip explicit member access modifiers
	/// if they match this modifier in order to avoid a compiler warning in the generated code.
	///
	/// This property will always be `nil` when the extension declares conformances.
	public let accessModifier: AccessModifierDescriptor?

	/// The attributes applied to the extension.
	public let attributes: [AttributeDescriptor]

	/// The type being extended.
	///
	/// - Note: Only nominal types can be extended: a plain identifier, qualified identifier, or a generic type
	/// 		with concrete arguments (such as `Array<Int>`). Existential, tuple, and function types
	/// 		are not valid here.
	public let extendedType: TypeReference

	/// The protocol conformances added by the extension.
	///
	/// Always empty when the extensions has an access level modifier.
	public let conformances: [TypeReference]

	/// The generic `where` requirements to narrow the extension.
	public let genericRequirements: [TypeConstraintDescriptor]

	/// The member declarations contained within the extension.
	public let members: [DeclarationDescriptor]

	/// Creates an extension descriptor.
	init(
		_ extendedType: TypeReference,
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		attributes: [AttributeDescriptor],
		conformances: [TypeReference],
		genericRequirements: [TypeConstraintDescriptor],
		members: [DeclarationDescriptor]
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.extendedType = extendedType
		self.conformances = conformances
		self.genericRequirements = genericRequirements
		self.members = members
	}

	/// Creates an extension that adds members to a type, optionally at a default access level.
	///
	/// An extension with an access level modifier cannot also declare conformances; use
	/// ``init(_:comment:attributes:conformances:genericRequirements:members:)``
	///
	/// - Parameters:
	///   - extendedType: The type being extended.
	///   - comment: An optional documentation comment for the extension.
	///   - accessModifier: An optional access level modifier, which becomes the default
	///   					for the extension's members.
	///   - attributes: Attributes applied to the extension.
	///   - genericRequirements: The generic `where` requirements that narrow the
	///   						 extension.
	///   - members: The member descriptors contained within the extension.
	public init(
		_ extendedType: TypeReference,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) {
		self.init(
			extendedType,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			conformances: [],
			genericRequirements: genericRequirements,
			members: members()
		)
	}

	/// Creates an extension that adds protocol conformances to a type.
	///
	/// Swift does not permit an access level modifier on an extension that declares
	/// conformances, so this initializer offers no access modifier parameter. Members
	/// that satisfy requirements of a protocol must declare their own access modifier
	/// that matches the protocol.
	///
	/// - Parameters:
	///   - extendedType: The type being extended.
	///   - comment: An optional documentation comment for the extension.
	///   - attributes: Attributes applied to the extension.
	///   - conformances: The protocols the extension adds conformances to.
	///   - genericRequirements: The generic `where` requirements that narrow the
	///   						 extension.
	///   - members: The member descriptors contained within the extension.
	public init(
		_ extendedType: TypeReference,
		comment: DocCommentDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		conformances: [TypeReference],
		genericRequirements: [TypeConstraintDescriptor] = [],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) {
		self.init(
			extendedType,
			comment: comment,
			accessModifier: nil,
			attributes: attributes,
			conformances: conformances,
			genericRequirements: genericRequirements,
			members: members()
		)
	}
}

public extension TopLevelDeclarationDescriptor {
	/// Creates an extension that adds members to a type, optionally at a default access level.
	///
	/// - Parameters:
	///   - extendedType: The type being extended.
	///   - comment: An optional documentation comment for the extension.
	///   - accessModifier: An optional access level modifier, which becomes the default
	///   					for the extension's members.
	///   - attributes: Attributes applied to the extension.
	///   - genericRequirements: The generic `where` requirements that narrow the
	///   						 extension.
	///   - members: The member descriptors contained within the extension.
	static func `extension`(
		_ extendedType: TypeReference,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) -> Self {
		Self.extension(ExtensionDescriptor(
			extendedType,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericRequirements: genericRequirements,
			members: members
		))
	}

	/// Creates an extension that adds protocol conformances to a type.
	///
	/// - Parameters:
	///   - extendedType: The type being extended.
	///   - comment: An optional documentation comment for the extension.
	///   - attributes: Attributes applied to the extension.
	///   - conformances: The protocols the extension adds conformances to.
	///   - genericRequirements: The generic `where` requirements that narrow the
	///   						 extension.
	///   - members: The member descriptors contained within the extension.
	static func `extension`(
		_ extendedType: TypeReference,
		comment: DocCommentDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		conformances: [TypeReference],
		genericRequirements: [TypeConstraintDescriptor] = [],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) -> Self {
		Self.extension(ExtensionDescriptor(
			extendedType,
			comment: comment,
			attributes: attributes,
			conformances: conformances,
			genericRequirements: genericRequirements,
			members: members
		))
	}
}

public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	/// Allows an ``ExtensionDescriptor`` to be used directly inside a top-level declaration
	/// builder. Wrapping it in ``TopLevelDeclarationDescriptor/extension(_:)``
	static func buildExpression(_ expression: ExtensionDescriptor) -> [T] {
		[.extension(expression)]
	}
}

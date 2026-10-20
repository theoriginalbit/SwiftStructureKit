//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A property declaration.
public struct PropertyDescriptor: Sendable {
	/// The property's storage or accessor form.
	public enum Kind: Sendable {
		/// A stored property, optionally initialized and observed.
		case stored(
			isMutable: Bool,
			defaultValue: ExpressionDescriptor? = nil,
			observers: [PropertyAccessorDescriptor.Observer] = [],
		)

		/// A computed property with a getter and an optional setter.
		case computed(
			getter: PropertyAccessorDescriptor.Getter,
			setter: PropertyAccessorDescriptor.Setter? = nil,
		)
	}

	/// The documentation comment attached to the property, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the property, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The attributes applied to the property.
	public let attributes: [AttributeDescriptor]

	/// Whether the property is static.
	public let isStatic: Bool

	/// The property's identifier.
	public let identifier: String

	/// The property's type.
	public let type: TypeReference

	/// The property's storage or accessor form.
	public let kind: Kind

	/// Creates a property descriptor.
	///
	/// - Parameters:
	///   - comment: An optional documentation comment for the property.
	///   - accessModifier: An optional access level modifier for the property.
	///   - attributes: Attributes applied to the property.
	///   - isStatic: Whether the property is static.
	///   - identifier: The property's identifier.
	///   - type: The property's type.
	///   - kind: The property's storage or accessor form.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isStatic: Bool = false,
		type: TypeReference,
		kind: Kind,
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.isStatic = isStatic
		self.identifier = identifier
		self.type = type
		self.kind = kind
	}
}

public extension PropertyDescriptor {
	/// Creates a mutable stored property.
	///
	/// - Parameters:
	///   - identifier: The property's identifier.
	///   - comment: An optional documentation comment.
	///   - accessModifier: An optional access modifier.
	///   - attributes: Attributes applied to the property.
	///   - isStatic: Whether the property is static.
	///   - type: The property's type.
	///   - defaultValue: An optional initial value.
	///   - observers: A result builder closure producing the property's `willSet` and `didSet` observers.
	static func `var`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isStatic: Bool = false,
		type: TypeReference,
		defaultValue: ExpressionDescriptor? = nil,
		@PropertyObserversBuilder observers: () -> [PropertyAccessorDescriptor.Observer] = { [] },
	) -> Self {
		Self(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			isStatic: isStatic,
			type: type,
			kind: .stored(isMutable: true, defaultValue: defaultValue, observers: observers()),
		)
	}

	/// Creates an immutable stored property.
	///
	/// - Parameters:
	///   - identifier: The property's identifier.
	///   - comment: An optional documentation comment.
	///   - accessModifier: An optional access modifier.
	///   - attributes: Attributes applied to the property.
	///   - isStatic: Whether the property is static.
	///   - type: The property's type.
	///   - defaultValue: An optional initial value.
	static func `let`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isStatic: Bool = false,
		type: TypeReference,
		defaultValue: ExpressionDescriptor? = nil,
	) -> Self {
		Self(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			isStatic: isStatic,
			type: type,
			kind: .stored(isMutable: false, defaultValue: defaultValue),
		)
	}

	/// Creates a computed property with a getter.
	///
	/// - Parameters:
	///   - identifier: The property's identifier.
	///   - comment: An optional documentation comment.
	///   - accessModifier: An optional access modifier.
	///   - attributes: Attributes applied to the property.
	///   - isStatic: Whether the property is static.
	///   - type: The property's type.
	///   - getterEffects: The getter's effect specifiers.
	///   - getter: A result builder closure producing the getter body.
	static func `var`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isStatic: Bool = false,
		type: TypeReference,
		getterEffects: EffectSpecifiers<ThrowingSpecifier> = .none,
		@CodeBlockBuilder getter: () -> [StatementDescriptor],
	) -> Self {
		computed(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			isStatic: isStatic,
			type: type,
			getterEffects: getterEffects,
			getter: getter,
		)
	}

	/// Creates a computed property with a getter and setter.
	///
	/// - Parameters:
	///   - identifier: The property's identifier.
	///   - comment: An optional documentation comment.
	///   - accessModifier: An optional access modifier.
	///   - attributes: Attributes applied to the property.
	///   - isStatic: Whether the property is static.
	///   - type: The property's type.
	///   - getterEffects: The getter's effect specifiers.
	///   - getter: A result builder closure producing the getter body.
	///   - setter: A result builder closure producing the setter body.
	static func `var`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isStatic: Bool = false,
		type: TypeReference,
		getterEffects: EffectSpecifiers<ThrowingSpecifier> = .none,
		@CodeBlockBuilder getter: () -> [StatementDescriptor],
		@CodeBlockBuilder setter: () -> [StatementDescriptor],
	) -> Self {
		computed(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			isStatic: isStatic,
			type: type,
			getterEffects: getterEffects,
			getter: getter,
			setter: setter,
		)
	}

	/// Creates a computed property with a getter.
	///
	/// - Parameters:
	///   - identifier: The property's identifier.
	///   - comment: An optional documentation comment.
	///   - accessModifier: An optional access modifier.
	///   - attributes: Attributes applied to the property.
	///   - isStatic: Whether the property is static.
	///   - type: The property's type.
	///   - getterEffects: The getter's effect specifiers.
	///   - getter: A result builder closure producing the getter body.
	static func computed(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isStatic: Bool = false,
		type: TypeReference,
		getterEffects: EffectSpecifiers<ThrowingSpecifier> = .none,
		@CodeBlockBuilder getter: () -> [StatementDescriptor],
	) -> Self {
		Self(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			isStatic: isStatic,
			type: type,
			kind: .computed(
				getter: .init(effects: getterEffects, body: getter)
			),
		)
	}

	/// Creates a computed property with a getter and setter.
	///
	/// - Parameters:
	///   - identifier: The property's identifier.
	///   - comment: An optional documentation comment.
	///   - accessModifier: An optional access modifier.
	///   - attributes: Attributes applied to the property.
	///   - isStatic: Whether the property is static.
	///   - type: The property's type.
	///   - getterEffects: The getter's effect specifiers.
	///   - getter: A result builder closure producing the getter body.
	///   - setter: A result builder closure producing the setter body.
	static func computed(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isStatic: Bool = false,
		type: TypeReference,
		getterEffects: EffectSpecifiers<ThrowingSpecifier> = .none,
		@CodeBlockBuilder getter: () -> [StatementDescriptor],
		@CodeBlockBuilder setter: () -> [StatementDescriptor],
	) -> Self {
		Self(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			isStatic: isStatic,
			type: type,
			kind: .computed(
				getter: .init(effects: getterEffects, body: getter),
				setter: .init(body: setter),
			),
		)
	}
}

public extension ArrayBuilder<DeclarationDescriptor> {
	static func buildExpression(_ expression: PropertyDescriptor) -> [T] {
		[.property(expression)]
	}
}

public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	static func buildExpression(_ expression: PropertyDescriptor) -> [T] {
		[.member(.property(expression))]
	}
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: PropertyDescriptor) -> Result {
		[.property(expression)]
	}
}

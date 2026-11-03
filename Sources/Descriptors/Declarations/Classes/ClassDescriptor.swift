//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a class declaration.
///
/// > Grammar:
/// > As described by The Swift Programming Language – "Summary of the Grammar" – [Grammar of a class declaration](https://docs.swift.org/latest/documentation/the-swift-programming-language/summaryofthegrammar#:~:text=Grammar%20of%20a%20class%20declaration)
public struct ClassDescriptor: Sendable {
	/// The documentation comment attached to the class declaration, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the class, if any.
	public let accessModifier: ClassAccessModifierDescriptor?

	/// The attributes applied to the class.
	public let attributes: [AttributeDescriptor]

	/// Whether the class should have the `final` keyword attached.
	public let isFinal: Bool

	/// The name identifier of the class.
	public let identifier: String

	/// The generic type parameters declared for the class.
	public let genericParameters: [GenericParameterDescriptor]

	/// The generic `where` requirements declared by the class.
	public let genericRequirements: [TypeConstraintDescriptor]

	/// The type and protocol conformances of the class.
	public let conformances: [TypeReference]

	/// The member declarations contained within the class.
	public let members: [DeclarationDescriptor]

	/// Creates a class descriptor.
	///
	/// - Parameters:
	///   - identifier: The name of the class.
	///   - comment: An optional documentation comment for the class.
	///   - accessModifier: An optional access level modifier for the class.
	///   - attributes: The attributes applied to the class.
	///   - isFinal: Whether the class should have the `final` keyword attached.
	///   - genericParameters: The generic parameters associated with the class.
	///   - genericRequirements: The generic `where` requirements declared by the class.
	///   - conformances: The types or protocols the class conforms to.
	///   - members: The member declarations contained within the class.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: ClassAccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isFinal: Bool = false,
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		members: [DeclarationDescriptor] = [],
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.isFinal = isFinal
		self.identifier = identifier
		self.genericParameters = genericParameters
		self.genericRequirements = genericRequirements
		self.conformances = conformances
		self.members = members
	}

	/// Creates a class descriptor using a result builder to define its members.
	///
	/// - Parameters:
	///   - identifier: The name of the class.
	///   - comment: An optional documentation comment for the class.
	///   - accessModifier: An optional access level modifier for the class.
	///   - attributes: The attributes applied to the class.
	///   - isFinal: Whether the class should have the `final` keyword attached.
	///   - genericParameters: The generic parameters associated with the class.
	///   - genericRequirements: The generic `where` requirements declared by the class.
	///   - conformances: The types or protocols the class conforms to.
	///   - members: A result builder closure producing the class's member declarations.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: ClassAccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isFinal: Bool = false,
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@DeclarationBuilder members: () -> [DeclarationDescriptor],
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.isFinal = isFinal
		self.identifier = identifier
		self.genericParameters = genericParameters
		self.genericRequirements = genericRequirements
		self.conformances = conformances
		self.members = members()
	}
}

public extension ArrayBuilder<DeclarationDescriptor> {
	static func buildExpression(_ expression: ClassDescriptor) -> [T] {
		[.class(expression)]
	}
}

public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	static func buildExpression(_ expression: ClassDescriptor) -> [T] {
		[.member(.class(expression))]
	}
}

public extension DeclarationDescriptor {
	/// Creates a member descriptor for a class.
	///
	/// - Parameters:
	///   - identifier: The name of the class.
	///   - comment: An optional documentation comment for the class.
	///   - accessModifier: An optional access level modifier for the class.
	///   - attributes: Attributes applied to the class.
	///   - isFinal: Whether the class should have the `final` keyword attached.
	///   - genericParameters: The generic parameters associated with the class.
	///   - genericRequirements: The generic `where` requirements associated with the class.
	///   - conformances: The types or protocols the class conforms to.
	///   - members: A result builder closure producing the class's member declarations.
	static func `class`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: ClassAccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		isFinal: Bool = false,
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) -> Self {
		.class(ClassDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			isFinal: isFinal,
			genericParameters: genericParameters,
			genericRequirements: genericRequirements,
			conformances: conformances,
			members: members,
		))
	}
}

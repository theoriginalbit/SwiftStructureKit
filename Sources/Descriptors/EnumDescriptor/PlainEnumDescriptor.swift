//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An enum kind representing plain enumerations that have neither raw values nor associated values.
@dynamicMemberLookup
public struct PlainEnumDescriptor: Sendable {
	let descriptor: AnyEnumDescriptor

	public subscript<T>(dynamicMember keyPath: KeyPath<AnyEnumDescriptor, T>) -> T {
		descriptor[keyPath: keyPath]
	}

	/// Creates a plain enum descriptor.
	///
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - attributes: Attributes applied to the enum.
	///   - genericParameters: The generic parameters associated with the enum.
	///   - genericRequirements: The generic `where` requirements associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@ArrayBuilder<PlainEnumCaseDescriptor> cases: () -> [PlainEnumCaseDescriptor] = { [] },
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) {
		descriptor = AnyEnumDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericParameters: genericParameters,
			genericRequirements: genericRequirements,
			conformances: conformances,
			cases: cases().map(\.descriptor),
			members: members()
		)
	}
}

// MARK: - Supporting Types

/// A descriptor representing a case declaration within a Swift enumeration.
@dynamicMemberLookup
public struct PlainEnumCaseDescriptor: Sendable {
	let descriptor: AnyEnumCaseDescriptor

	public subscript<T>(dynamicMember keyPath: KeyPath<AnyEnumCaseDescriptor, T>) -> T {
		descriptor[keyPath: keyPath]
	}

	/// Creates a plain enum case with a name and optional documentation comment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - comment: An optional documentation comment for the case.
	public init(
		_ name: String,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: nil,
			associatedValues: [],
			comment: comment,
		)
	}
}

// MARK: - Construction Conveniences

public extension ArrayBuilder<PlainEnumCaseDescriptor> {
	static func buildExpression(_ statement: String) -> [T] {
		[T(statement)]
	}
}

public extension ArrayBuilder<DeclarationDescriptor> {
	static func buildExpression(_ expression: PlainEnumDescriptor) -> [T] {
		[.enum(expression.descriptor)]
	}
}

public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	static func buildExpression(_ expression: PlainEnumDescriptor) -> [T] {
		[.member(.enum(expression.descriptor))]
	}
}

public extension DeclarationDescriptor {
	/// Creates a plain enum descriptor.
	///
	/// - Note: Uninhabited enum creation will go down this path.
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - attributes: Attributes applied to the enum.
	///   - genericParameters: The generic parameters associated with the enum.
	///   - genericRequirements: The generic `where` requirements associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	static func `enum`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@ArrayBuilder<PlainEnumCaseDescriptor> cases: () -> [PlainEnumCaseDescriptor] = { [] },
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) -> Self {
		Self.enum(PlainEnumDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericParameters: genericParameters,
			genericRequirements: genericRequirements,
			conformances: conformances,
			cases: cases,
			members: members,
		).descriptor)
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An enum kind representing enumerations that use associated values.
@dynamicMemberLookup
public struct AssociatedValueEnumDescriptor: Sendable {
	let descriptor: AnyEnumDescriptor

	public subscript<T>(dynamicMember keyPath: KeyPath<AnyEnumDescriptor, T>) -> T {
		descriptor[keyPath: keyPath]
	}

	/// Creates an enum with associated values descriptor.
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
		@ArrayBuilder<AssociatedValueEnumCaseDescriptor> cases: () -> [AssociatedValueEnumCaseDescriptor],
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
			members: members(),
		)
	}
}

// MARK: - Construction Conveniences

public extension ArrayBuilder<DeclarationDescriptor> {
	static func buildExpression(_ expression: AssociatedValueEnumDescriptor) -> [T] {
		[.enum(expression.descriptor)]
	}
}

public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	static func buildExpression(_ expression: AssociatedValueEnumDescriptor) -> [T] {
		[.member(.enum(expression.descriptor))]
	}
}

public extension DeclarationDescriptor {
	/// Creates an enum with associated values descriptor.
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
	@_disfavoredOverload static func `enum`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericParameters: [GenericParameterDescriptor] = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference] = [],
		@ArrayBuilder<AssociatedValueEnumCaseDescriptor> associatedValueCases cases: () -> [AssociatedValueEnumCaseDescriptor],
		@DeclarationBuilder members: () -> [DeclarationDescriptor] = { [] },
	) -> Self {
		Self.enum(AssociatedValueEnumDescriptor(
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

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import OrderedCollections

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
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	public init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericTypes: OrderedSet<TypeReference> = [],
		conformances: OrderedSet<TypeReference> = [],
		@ArrayBuilder<AssociatedValueEnumCaseDescriptor> cases: () -> [AssociatedValueEnumCaseDescriptor],
		@TypeMembersBuilder members: () -> [TypeMemberDescriptor] = { [] },
	) {
		descriptor = AnyEnumDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericTypes: genericTypes,
			conformances: conformances,
			cases: cases().map(\.descriptor),
			members: members(),
		)
	}
}

// MARK: - Supporting Types

/// A descriptor representing a case declaration within a Swift enumeration.
@dynamicMemberLookup
public struct AssociatedValueEnumCaseDescriptor: Sendable {
	let descriptor: AnyEnumCaseDescriptor

	public subscript<T>(dynamicMember keyPath: KeyPath<AnyEnumCaseDescriptor, T>) -> T {
		descriptor[keyPath: keyPath]
	}

	/// Creates an associated-value enum case with associated values and an optional documentation comment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - associatedValues: The associated values for the case.
	///   - comment: An optional documentation comment for the case.
	public init(
		_ name: String,
		associatedValues: [EnumCaseAssociatedValueDescriptor] = [],
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: nil,
			associatedValues: associatedValues,
			comment: comment,
		)
	}
}

// MARK: - Construction Conveniences

public extension ArrayBuilder where T == AssociatedValueEnumCaseDescriptor {
	static func buildExpression(_ statement: String) -> [T] {
		[T(statement)]
	}
}

public extension ArrayBuilder<TypeMemberDescriptor> {
	static func buildExpression(_ expression: AssociatedValueEnumDescriptor) -> [T] {
		[.enum(expression.descriptor)]
	}
}

public extension TypeMemberDescriptor {
	/// Creates an enum with associated values descriptor.
	///
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - attributes: Attributes applied to the enum.
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	@_disfavoredOverload static func `enum`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		genericTypes: OrderedSet<TypeReference> = [],
		conformances: OrderedSet<TypeReference> = [],
		@ArrayBuilder<AssociatedValueEnumCaseDescriptor> associatedValueCases cases: () -> [AssociatedValueEnumCaseDescriptor],
		@TypeMembersBuilder members: () -> [TypeMemberDescriptor] = { [] },
	) -> Self {
		Self.enum(AssociatedValueEnumDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			genericTypes: genericTypes,
			conformances: conformances,
			cases: cases,
			members: members,
		).descriptor)
	}
}

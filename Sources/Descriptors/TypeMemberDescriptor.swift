//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for a member of a type, such as a function or initializer.
public enum TypeMemberDescriptor: Sendable {
	/// A member that is a function, represented by its ``FunctionDescriptor``.
	case function(FunctionDescriptor)

	/// A member that is an enum, represented by its ``EnumDescriptor``.
	case `enum`(AnyEnumDescriptor)

	/// A member that is a struct, represented by its ``StructDescriptor``.
	case `struct`(StructDescriptor)

	/// A member that is a mark comment, represented by its ``MarkCommentDescriptor``
	case mark(MarkCommentDescriptor)
}

public extension TypeMemberDescriptor {
	// MARK: - Function Conveniences

	/// Creates a member descriptor for an initializer.
	///
	/// - Parameters:
	///   - comment: An optional documentation comment for the initializer.
	///   - accessModifier: An optional access modifier (e.g. `public`, `private`) for the initializer.
	///   - failable: Whether the initializer is failable (i.e. `init?`).
	///   - parameters: The list of parameters the initializer accepts. Defaults to an empty list.
	///   - effects: Optional effect specifiers (e.g. `throws`, `async`) for the initializer.
	///   - body: A ``CodeBlockBuilder`` closure that produces the statements making up the initializer's body.
	/// - Returns: A `.function` member descriptor configured as an initializer.
	static func initializer(
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		failable: Bool,
		parameters: ParametersList = [],
		effects: EffectSpecifiers? = nil,
		@CodeBlockDescriptor.Builder body: () -> CodeBlockDescriptor.Builder.Result,
	) -> Self {
		Self.function(FunctionDescriptor(
			signature: .init(
				comment: comment,
				accessModifier: accessModifier,
				kind: .initializer(failable: failable),
				parameters: parameters,
				effects: effects,
			),
			body: body,
		))
	}

	/// Creates a member descriptor for a function.
	///
	/// - Parameters:
	///   - comment: An optional documentation comment for the function.
	///   - accessModifier: An optional access modifier (e.g. `public`, `private`) for the function.
	///   - name: The name of the function.
	///   - returns: An optional ``TypeReference`` describing the function's return type. Defaults to `nil` (no return value).
	///   - isStatic: Whether the function is a static member. Defaults to `false`.
	///   - parameters: The list of parameters the function accepts. Defaults to an empty list.
	///   - effects: Optional effect specifiers (e.g. `throws`, `async`) for the function.
	///   - body: A ``CodeBlockBuilder`` closure that produces the statements making up the function's body.
	/// - Returns: A `.function` member descriptor configured as a named function.
	static func function(
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		name: String,
		returns: TypeReference? = nil,
		isStatic: Bool = false,
		parameters: ParametersList = [],
		effects: EffectSpecifiers? = nil,
		@CodeBlockDescriptor.Builder body: () -> CodeBlockDescriptor.Builder.Result,
	) -> Self {
		Self.function(FunctionDescriptor(
			signature: .init(
				comment: comment,
				accessModifier: accessModifier,
				kind: .function(
					name,
					returns: returns,
					isStatic: isStatic
				),
				parameters: parameters,
				effects: effects,
			),
			body: body,
		))
	}

	// MARK: - Enum Conveniences

	/// Creates a plain enum descriptor.
	///
	/// - Note: Uninhabited enum creation will go down this path.
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	static func `enum`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		@ArrayBuilder<PlainEnumCaseDescriptor> cases: () -> [PlainEnumCaseDescriptor] = { [] },
		@TypeMembersBuilder members: () -> TypeMembersBuilder.Result = { [] },
	) -> Self {
		Self.enum(PlainEnumDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			genericTypes: genericTypes,
			conformances: conformances,
			cases: cases,
			members: members,
		).descriptor)
	}

	/// Creates an enum with raw values descriptor.
	///
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	@_disfavoredOverload static func `enum`<RawValueType: RawValueEnumValueType>(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		@ArrayBuilder<RawValueEnumCaseDescriptor<RawValueType>> rawValueCases cases: () -> [RawValueEnumCaseDescriptor<RawValueType>],
		@TypeMembersBuilder members: () -> TypeMembersBuilder.Result = { [] },
	) -> Self {
		Self.enum(RawValueEnumDescriptor<RawValueType>(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			genericTypes: genericTypes,
			conformances: conformances,
			cases: cases,
			members: members,
		).descriptor)
	}

	/// Creates an enum with associated values descriptor.
	///
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: A result builder closure producing the case descriptors for the enum.
	///   - members: A result builder closure producing the member descriptors contained within the enum.
	@_disfavoredOverload static func `enum`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		@ArrayBuilder<AssociatedValueEnumCaseDescriptor> associatedValueCases cases: () -> [AssociatedValueEnumCaseDescriptor],
		@TypeMembersBuilder members: () -> TypeMembersBuilder.Result = { [] },
	) -> Self {
		Self.enum(AssociatedValueEnumDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			genericTypes: genericTypes,
			conformances: conformances,
			cases: cases,
			members: members,
		).descriptor)
	}

	// MARK: - Struct Conveniences

	/// Creates a member descriptor for a struct.
	///
	/// - Parameters:
	///   - identifier: The name of the struct.
	///   - comment: An optional documentation comment for the struct.
	///   - accessModifier: An optional access level modifier for the struct.
	///   - genericTypes: The generic type parameters associated with the struct.
	///   - conformances: The types or protocols the struct conforms to.
	///   - members: A result builder closure producing the member descriptors contained within the struct.
	static func `struct`(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: [TypeReference] = [],
		conformances: [TypeReference] = [],
		@TypeMembersBuilder members: () -> TypeMembersBuilder.Result,
	) -> Self {
		Self.struct(StructDescriptor(
			identifier,
			comment: comment,
			accessModifier: accessModifier,
			genericTypes: genericTypes,
			conformances: conformances,
			members: members(),
		))
	}

	// MARK: - Mark Conveniences

	static func mark(
		_ value: String?,
		sectionBreak: Bool = false
	) -> Self {
		Self.mark(MarkCommentDescriptor(
			value,
			sectionBreak: sectionBreak,
		))
	}
}

public extension ArrayBuilder<TypeMemberDescriptor> {
	static func buildExpression(_ expression: FunctionDescriptor) -> [T] {
		[.function(expression)]
	}

	static func buildExpression(_ expression: AnyEnumDescriptor) -> [T] {
		[.enum(expression)]
	}

	static func buildExpression(_ expression: PlainEnumDescriptor) -> [T] {
		[.enum(expression.descriptor)]
	}

	static func buildExpression(_ expression: RawValueEnumDescriptor<some RawValueEnumValueType>) -> [T] {
		[.enum(expression.descriptor)]
	}

	static func buildExpression(_ expression: AssociatedValueEnumDescriptor) -> [T] {
		[.enum(expression.descriptor)]
	}

	static func buildExpression(_ expression: StructDescriptor) -> [T] {
		[.struct(expression)]
	}

	static func buildExpression(_ expression: MarkCommentDescriptor) -> [T] {
		[.mark(expression)]
	}
}

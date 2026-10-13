//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import Collections

/// Type-erased representation of any enumeration declaration.
public struct AnyEnumDescriptor: Sendable {
	/// The documentation comment attached to the enum definition, if any.
	public let comment: DocCommentDescriptor?

	/// The access level modifier specified for the enum, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// The name identifier of the enum.
	public let identifier: String

	/// The generic type parameters declared for the enum.
	public let genericTypes: OrderedSet<TypeReference>

	/// The type and protocol conformances of the enum.
	public let conformances: OrderedSet<TypeReference>

	/// The cases of the enum.
	public let cases: [AnyEnumCaseDescriptor]

	/// The member declarations contained within the enum.
	public let members: [TypeMemberDescriptor]

	/// Creates an enum descriptor.
	///
	/// - Parameters:
	///   - identifier: The name of the enum.
	///   - comment: An optional documentation comment for the enum.
	///   - accessModifier: An optional access level modifier for the enum.
	///   - genericTypes: The generic type parameters associated with the enum.
	///   - conformances: The types or protocols the enum conforms to.
	///   - cases: The case descriptors for the enum.
	///   - members: The member descriptors contained within the enum.
	internal init(
		_ identifier: String,
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		genericTypes: OrderedSet<TypeReference> = [],
		conformances: OrderedSet<TypeReference> = [],
		cases: [AnyEnumCaseDescriptor] = [],
		members: [TypeMemberDescriptor] = [],
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.identifier = identifier
		self.genericTypes = genericTypes
		self.conformances = conformances
		self.cases = cases
		self.members = members
	}
}

/// Type-erased representation of any enumeration case declaration.
public struct AnyEnumCaseDescriptor: Sendable {
	/// The name identifier of the enum case.
	public let name: String

	/// The raw value associated with the enum case, if any.
	public let rawValue: LiteralDescriptor?

	/// The associated values attached to the enum case.
	public let associatedValues: [EnumCaseAssociatedValueDescriptor]

	/// The documentation comment attached to the enum case declaration, if any.
	public let comment: DocCommentDescriptor?

	internal init(
		name: String,
		rawValue: LiteralDescriptor?,
		associatedValues: [EnumCaseAssociatedValueDescriptor],
		comment: DocCommentDescriptor?
	) {
		self.name = name
		self.rawValue = rawValue
		self.associatedValues = associatedValues
		self.comment = comment
	}
}

/// A descriptor representing an associated value attached to an enum case.
public struct EnumCaseAssociatedValueDescriptor: Sendable {
	/// The optional label for the associated value.
	public let label: String?

	/// The type of the associated value.
	public let type: TypeReference

	/// An optional default value of the associated value.
	public let defaultValue: ExpressionDescriptor?

	/// Creates an associated value descriptor with an optional label, type, and optional default value.
	///
	/// - Parameters:
	///   - label: An optional argument label for the associated value.
	///   - type: The type reference of the associated value.
	///   - defaultValue: An optional default value for the associated value.
	public init(
		label: String? = nil,
		type: TypeReference,
		defaultValue: ExpressionDescriptor? = nil,
	) {
		self.label = label
		self.type = type
		self.defaultValue = defaultValue
	}
}

public extension ArrayBuilder<TypeMemberDescriptor> {
	static func buildExpression(_ expression: AnyEnumDescriptor) -> [T] {
		[.enum(expression)]
	}
}

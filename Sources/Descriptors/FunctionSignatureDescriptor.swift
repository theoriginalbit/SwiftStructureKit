//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public import OrderedCollections

/// A function signature.
public struct FunctionSignatureDescriptor: Sendable {
	/// A function parameter.
	public typealias Parameter = ParametersList.Parameter

	/// A function kind: `init` or `func`.
	public enum Kind: Sendable {
		/// An initializer.
		case initializer(failable: Bool)

		/// A function. Can be global or inhabiting a type as an instance function or static function.
		case function(_ name: String, returns: TypeReference? = nil, isStatic: Bool = false)
	}

	/// A comment to document the function.
	public let comment: DocCommentDescriptor?

	/// An access modifier.
	public let accessModifier: AccessModifierDescriptor?

	/// The attributes applied to the function.
	public let attributes: [AttributeDescriptor]

	/// The kind of the function, such as `init` or `func`; which requires a name and whether it is static.
	public let kind: Kind

	/// The function parameters that would be accepted as arguments.
	public let parameters: ParametersList

	/// The generic parameters declared by the function.
	public let genericParameters: OrderedSet<GenericParameterDescriptor>

	/// The generic `where` requirements declared by the function.
	public let genericRequirements: [TypeConstraintDescriptor]

	/// The effect specifiers of the function, such as `async` and `throws`.
	public let effects: EffectSpecifiers

	/// Creates a function signature.
	///
	/// - Parameters:
	///   - comment: An optional documentation comment for the function.
	///   - accessModifier: An optional access modifier for the function.
	///   - attributes: The attributes applied to the function.
	///   - kind: Whether the declaration is an initializer or named function.
	///   - parameters: The parameters accepted by the function.
	///   - effects: The function's `async` and throwing specifiers.
	public init(
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [AttributeDescriptor] = [],
		kind: Kind,
		parameters: ParametersList = [],
		genericParameters: OrderedSet<GenericParameterDescriptor> = [],
		genericRequirements: [TypeConstraintDescriptor] = [],
		effects: EffectSpecifiers = .none
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.kind = kind
		self.parameters = parameters
		self.genericParameters = genericParameters
		self.genericRequirements = genericRequirements
		self.effects = effects
	}
}

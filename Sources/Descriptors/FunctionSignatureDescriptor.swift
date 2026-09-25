//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

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

	/// The kind of the function, such as `init` or `func`; which requires a name and whether it is static.
	public let kind: Kind

	/// The function parameters that would be accepted as arguments.
	public let parameters: ParametersList

	/// The effect specifiers of the function, such as `async` and `throws`.
	public let effects: EffectSpecifiers?

	public init(
		comment: DocCommentDescriptor? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		kind: Kind,
		parameters: ParametersList = [],
		effects: EffectSpecifiers? = nil
	) {
		self.comment = comment
		self.accessModifier = accessModifier
		self.kind = kind
		self.parameters = parameters
		self.effects = effects
	}
}

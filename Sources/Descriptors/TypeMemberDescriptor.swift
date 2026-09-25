//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for a member of a type, such as a function or initializer.
public enum TypeMemberDescriptor: Sendable {
	/// A member that is a function, represented by its ``FunctionDescriptor``.
	case function(FunctionDescriptor)

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
		@CodeBlockBuilder body: () -> [StatementDescriptor],
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
		@CodeBlockBuilder body: () -> [StatementDescriptor],
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
}

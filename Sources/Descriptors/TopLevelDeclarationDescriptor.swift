//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A result builder for composing the top-level declarations of a ``SwiftFile``
public typealias TopLevelDeclarationBuilder = ArrayBuilder<TopLevelDeclarationDescriptor>

/// A declaration that can appear at the top-level of a ``SwiftFile``.
///
/// Most declarations are valid both at the file scope and as a member of a type; declared in
/// ``DeclarationDescriptor``. Extensions, however, can only appear at the file scope, so
/// have no counterpart in `DeclarationDescriptor`.
public enum TopLevelDeclarationDescriptor: Sendable {
	/// A declaration that is also valid as a type member, such as a type, function, property
	/// typealias, or MARK comment represented by its ``DeclarationDescriptor``.
	case member(DeclarationDescriptor)

	/// An extension of an existing type, represented by its ``ExtensionDescriptor``.
	case `extension`(ExtensionDescriptor)
}

/// The top-level builder accepts everything the ``DeclarationBuilder`` does, so that
/// a file body can read the same as a type body while additionally accepting extensions.
public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	/// Allows a ``DeclarationDescriptor`` to be used directly inside a top-level declaration
	/// builder. Wrapping it in ``TopLevelDeclarationDescriptor\member(_:)``
	static func buildExpression(_ expression: DeclarationDescriptor) -> [T] {
		[.member(expression)]
	}
}

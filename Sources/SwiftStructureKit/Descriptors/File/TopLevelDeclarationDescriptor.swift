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
	/// Not truely a statement, but allows for simple addition to a ``CodeBlockDescriptor``
	case comment(InlineCommentDescriptor)

	/// An extension of an existing type, represented by its ``ExtensionDescriptor``.
	case `extension`(ExtensionDescriptor)

	/// A declaration that is also valid as a type member, such as a type, function, property
	/// typealias, or MARK comment represented by its ``DeclarationDescriptor``.
	case member(DeclarationDescriptor)
}

public extension TopLevelDeclarationDescriptor {
	/// A member that is an enum, represented by its ``AnyEnumDescriptor``.
	static func `enum`(_ descriptor: AnyEnumDescriptor) -> Self {
		.member(.enum(descriptor))
	}

	/// A member that is a function, represented by its ``FunctionDescriptor``.
	static func function(_ descriptor: FunctionDescriptor) -> Self {
		.member(.function(descriptor))
	}

	/// A member that is a mark comment, represented by its ``MarkCommentDescriptor``
	static func mark(_ descriptor: MarkCommentDescriptor) -> Self {
		.member(.mark(descriptor))
	}

	/// A member that is a property, represented by its ``PropertyDescriptor``.
	static func property(_ descriptor: PropertyDescriptor) -> Self {
		.member(.property(descriptor))
	}

	/// A member that is a protocol, represented by its ``ProtocolDescriptor``.
	static func `protocol`(_ descriptor: ProtocolDescriptor) -> Self {
		.member(.protocol(descriptor))
	}

	/// A member that is a struct, represented by its ``StructDescriptor``.
	static func `struct`(_ descriptor: StructDescriptor) -> Self {
		.member(.struct(descriptor))
	}

	/// A member that is a class, represented by its ``ClassDescriptor``.
	static func `class`(_ descriptor: ClassDescriptor) -> Self {
		.member(.class(descriptor))
	}

	/// A member that is a typealias, represented by its ``TypealiasDescriptor``.
	static func `typealias`(_ descriptor: TypealiasDescriptor) -> Self {
		.member(.typealias(descriptor))
	}
}

/// The top-level builder accepts everything the ``DeclarationBuilder`` does, so that
/// a file body can read the same as a type body while additionally accepting extensions.
public extension ArrayBuilder<TopLevelDeclarationDescriptor> {
	/// Allows a ``DeclarationDescriptor`` to be used directly inside a top-level declaration
	/// builder. Wrapping it in ``TopLevelDeclarationDescriptor/member(_:)``
	static func buildExpression(_ expression: DeclarationDescriptor) -> [T] {
		[.member(expression)]
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for a member of a type, such as a function or initializer.
public enum TypeMemberDescriptor: Sendable {
	/// A member that is an enum, represented by its ``EnumDescriptor``.
	case `enum`(AnyEnumDescriptor)

	/// A member that is a function, represented by its ``FunctionDescriptor``.
	case function(FunctionDescriptor)

	/// A member that is a mark comment, represented by its ``MarkCommentDescriptor``
	case mark(MarkCommentDescriptor)

	/// A member that is a property, represented by its ``PropertyDescriptor``.
	case property(PropertyDescriptor)

	/// A member that is a protocol, represented by its ``ProtocolDescriptor``.
	case `protocol`(ProtocolDescriptor)

	/// A member that is a struct, represented by its ``StructDescriptor``.
	case `struct`(StructDescriptor)

	/// A member that is a typealias, represented by its ``TypealiasDescriptor``.
	case `typealias`(TypealiasDescriptor)
}

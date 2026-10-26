//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A member access expression.
///
/// For example `foo.bar`.
public struct MemberAccessDescriptor: Sendable {
	/// The expression of which a member `right` is accessed.
	///
	/// For example, in `foo.bar`, `left` represents `foo`.
	public let left: ExpressionDescriptor?

	/// The member name to access.
	///
	/// For example, in `foo.bar`, `right` is `bar`.
	public let right: String

	/// A member access expression.
	///
	/// For example `foo.bar`.
	public init(_ left: ExpressionDescriptor?, _ right: String) {
		self.left = left
		self.right = right
	}

	/// A member access expression.
	///
	/// For example `foo.bar`.
	public static func memberAccess(_ left: ExpressionDescriptor?, _ right: String) -> Self {
		MemberAccessDescriptor(left, right)
	}

	/// A member access expression.
	///
	/// For example `foo.bar`.
	public static func memberAccess(_ left: String?, _ right: String) -> Self {
		MemberAccessDescriptor(
			left.map(ExpressionDescriptor.identifier(_:)),
			right
		)
	}

	/// A member access expression.
	///
	/// For example `foo.bar`.
	public static func selfMember(_ right: String) -> Self {
		MemberAccessDescriptor(.identifier("self"), right)
	}
}

public extension ExpressionDescriptor {
	/// A member access expression.
	///
	/// For example: `foo.bar` or `.bar`.
	static func memberAccess(_ left: ExpressionDescriptor?, _ right: String) -> Self {
		.memberAccess(MemberAccessDescriptor(left, right))
	}

	/// A member access expression.
	///
	/// For example: `foo.bar` or `.bar`.
	static func memberAccess(_ left: String, _ right: String) -> Self {
		.memberAccess(MemberAccessDescriptor(.identifier(left), right))
	}
}
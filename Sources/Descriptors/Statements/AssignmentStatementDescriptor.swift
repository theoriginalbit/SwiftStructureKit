//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An assignment of an expression to a target, such as `name = "Luke"` or `self.age = age`.
public struct AssignmentStatementDescriptor: Sendable {
	/// The variable expression on the left-hand side of the assignment operator.
	///
	/// For example in `foo = bar`, `left` is `foo`.
	public let left: ExpressionDescriptor

	/// The value expression on the right-hand side of the assignment operator.
	///
	/// For example in `foo = bar`, `right` is `bar`.
	public let right: ExpressionDescriptor

	/// An assignment statement.
	///
	/// Declared with `left` as a ``TypeIdentifier``, so for example `name = "Leia` then `left` is `name`.
	///
	/// - Parameters:
	///   - left: The variable expression.
	///   - right: The value expression.
	public init(_ left: TypeIdentifier, _ right: ExpressionDescriptor) {
		self.left = .identifier(left)
		self.right = right
	}

	/// An assignment statement.
	///
	/// Declared with `left` as ``MemberAccessDescriptor``, so for example `self.name = "Leia` then `left` is `self.name`.
	///
	/// - Parameters:
	///   - left: The variable expression.
	///   - right: The value expression.
	public init(_ left: MemberAccessDescriptor, _ right: ExpressionDescriptor) {
		self.left = .memberAccess(left)
		self.right = right
	}
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: AssignmentStatementDescriptor) -> Result {
		[.assignment(expression)]
	}
}

public extension StatementDescriptor {
	/// An assignment statement.
	///
	/// - Parameters:
	///   - left: The variable expression.
	///   - right: The value expression.
	static func assignment(_ left: TypeIdentifier, _ right: ExpressionDescriptor) -> Self {
		.assignment(AssignmentStatementDescriptor(left, right))
	}

	/// An assignment statement.
	///
	/// Declared with `left` as ``MemberAccessDescriptor``, so for example `self.name = "Leia` then `left` is `self.name`.
	///
	/// - Parameters:
	///   - left: The variable expression.
	///   - right: The value expression.
	static func assignment(_ left: MemberAccessDescriptor, _ right: ExpressionDescriptor) -> Self {
		.assignment(AssignmentStatementDescriptor(left, right))
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A nil-coalescing expression.
///
/// For example `foo ?? bar`.
public struct NilCoalescingDescriptor: Sendable {
	/// The left expression.
	///
	/// For example, in `foo ?? bar`, `left` represents `foo`.
	public let left: ExpressionDescriptor

	/// The right expression.
	///
	/// For example, in `foo ?? bar`, `right` is `bar`.
	public let right: ExpressionDescriptor

	/// A nil-coalescing expression.
	///
	/// For example `foo ?? bar`.
	public init(_ left: ExpressionDescriptor, _ right: ExpressionDescriptor) {
		self.left = left
		self.right = right
	}
}

public extension ExpressionDescriptor {
	/// A nil-coalescing expression.
	///
	/// - Note: No automatic detection to add parentheses based on precedence group has been
	/// 		implemented. Use ``parenthesized(_:)`` to add explicit grouping.
	///
	/// - Parameters:
	///   - left: The left-hand expression.
	///   - right: The right-hand fallback expression.
	static func nilCoalescing(_ left: ExpressionDescriptor, _ right: ExpressionDescriptor) -> Self {
		.nilCoalescing(NilCoalescingDescriptor(left, right))
	}

	/// A nil-coalescing expression with an identifier on the left and an expression on the right.
	///
	/// - Note: No automatic detection to add parentheses based on precedence group has been
	/// 		implemented. Use ``parenthesized(_:)`` to add explicit grouping.
	///
	/// - Parameters:
	///   - left: The identifier name for the left-hand expression.
	///   - right: The right-hand fallback expression.
	static func nilCoalescing(_ left: String, _ right: ExpressionDescriptor) -> Self {
		.nilCoalescing(NilCoalescingDescriptor(.identifier(left), right))
	}

	/// A nil-coalescing expression with an identifier on the left and the right.
	///
	/// - Note: No automatic detection to add parentheses based on precedence group has been
	/// 		implemented. Use ``parenthesized(_:)`` to add explicit grouping.
	///
	/// - Parameters:
	/// - left: The identifier name for the left-hand expression.
	/// - right: The identifier name for the right-hand fallback expression.
	static func nilCoalescing(_ left: String, _ right: String) -> Self {
		.nilCoalescing(NilCoalescingDescriptor(.identifier(left), .identifier(right)))
	}

	/// A nil-coalescing expression with an expression on the left and an identifier on the right.
	///
	/// - Note: No automatic detection to add parentheses based on precedence group has been
	/// 		implemented. Use ``parenthesized(_:)`` to add explicit grouping.
	///
	/// - Parameters:
	/// - left: The identifier name for the left-hand expression.
	/// - right: The identifier name for the right-hand fallback expression.
	static func nilCoalescing(_ left: ExpressionDescriptor, _ right: String) -> Self {
		.nilCoalescing(NilCoalescingDescriptor(left, .identifier(right)))
	}

	/// A nil-coalescing expression with a literal on the right.
	///
	/// - Note: No automatic detection to add parentheses based on precedence group has been
	/// 		implemented. Use ``parenthesized(_:)`` to add explicit grouping.
	///
	/// - Parameters:
	///   - left: The left-hand expression.
	///   - right: The right-hand literal fallback value.
	@_disfavoredOverload static func nilCoalescing(_ left: ExpressionDescriptor, _ right: LiteralDescriptor) -> Self {
		.nilCoalescing(NilCoalescingDescriptor(left, .literal(right)))
	}

	/// A nil-coalescing expression with an identifier on the left and a literal on the right.
	///
	/// - Note: No automatic detection to add parentheses based on precedence group has been
	/// 		implemented. Use ``parenthesized(_:)`` to add explicit grouping.
	///
	/// - Parameters:
	///   - left: The identifier name for the left-hand expression.
	///   - right: The right-hand literal fallback value.
	@_disfavoredOverload static func nilCoalescing(_ left: String, _ right: LiteralDescriptor) -> Self {
		.nilCoalescing(NilCoalescingDescriptor(.identifier(left), .literal(right)))
	}
}

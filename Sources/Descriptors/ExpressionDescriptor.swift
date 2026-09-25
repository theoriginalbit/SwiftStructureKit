//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for Swift expressions.
public struct ExpressionDescriptor: Sendable {
	/// The kind of expression.
	public enum Kind: Sendable {
		/// A literal expression.
		case literal(LiteralDescriptor)
	}

	/// The underlying kind of expression.
	public let kind: Kind

	/// Creates an expression with a given kind.
	public init(_ kind: Kind) {
		self.kind = kind
	}
}

// MARK: - Conveniences

public extension ExpressionDescriptor {
	/// Creates a literal expression.
	static func literal(_ literal: LiteralDescriptor) -> Self {
		Self(.literal(literal))
	}
}

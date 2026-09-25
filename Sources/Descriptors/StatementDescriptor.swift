//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for Swift statements.
public struct StatementDescriptor: Sendable {
	/// The kind of statement.
	public indirect enum Kind: Sendable {
		/// A return statement with an optional return expression.
		case `return`(ExpressionDescriptor?)
	}

	/// The underlying kind of statement.
	public let kind: Kind

	/// Creates a statement with a given kind.
	public init(_ kind: Kind) {
		self.kind = kind
	}
}

// MARK: - Convenience

public extension StatementDescriptor {
	/// Creates a return statement.
	static func `return`(_ expression: ExpressionDescriptor? = nil) -> Self {
		Self(.return(expression))
	}
}

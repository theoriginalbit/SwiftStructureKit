//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for Swift statements.
public struct StatementDescriptor: Sendable {
	/// The kind of statement.
	public indirect enum Kind: Sendable {
		/// An assignment statement, declaring a variable or constant.
		///
		/// - Parameters:
		///   - isMutable: A Boolean value indicating whether the declaration is mutable (`var`) or immutable (`let`).
		///   - identifier: The variable or constant identifier.
		///   - type: The type reference of the variable or constant.
		///   - expression: An optional initial value expression assigned to the declaration.
		case assignment(isMutable: Bool, identifier: String, type: TypeReference, expression: ExpressionDescriptor?)

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
	static func assignment(isMutable: Bool = false, identifier: String, type: TypeReference, expression: ExpressionDescriptor? = nil) -> Self {
		Self(.assignment(isMutable: isMutable, identifier: identifier, type: type, expression: expression))
	}

	static func `var`(_ identifier: String, type: TypeReference, expression: ExpressionDescriptor? = nil) -> Self {
		Self.assignment(isMutable: true, identifier: identifier, type: type, expression: expression)
	}

	static func `let`(_ identifier: String, type: TypeReference, expression: ExpressionDescriptor? = nil) -> Self {
		Self.assignment(isMutable: false, identifier: identifier, type: type, expression: expression)
	}

	/// Creates a return statement.
	static func `return`(_ expression: ExpressionDescriptor? = nil) -> Self {
		Self(.return(expression))
	}
}

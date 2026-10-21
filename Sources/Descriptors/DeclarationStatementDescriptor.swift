//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A statement that declares a variable or constant.
public struct DeclarationStatementDescriptor: Sendable {
	public enum Kind: Sendable {
		case `var`
		case `let`
	}

	/// Whether the declaration is `var` `let`.
	public let kind: Kind

	/// The variable or constant identifier.
	public let identifier: String

	/// The type reference of the variable or constant.
	public let type: TypeReference

	/// An optional initial value expression assigned to the declaration.
	public let expression: ExpressionDescriptor?

	/// A declaration statement.
	///
	/// - Parameters:
	///   - kind: Whether the declaration is `var` `let`.
	///   - identifier: The variable or constant identifier.
	///   - type: The type reference of the variable or constant.
	///   - expression: An optional initial value expression assigned to the declaration.
	public init(
		_ kind: Kind,
		identifier: String,
		type: TypeReference,
		expression: ExpressionDescriptor? = nil
	) {
		self.kind = kind
		self.identifier = identifier
		self.type = type
		self.expression = expression
	}
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: DeclarationStatementDescriptor) -> Result {
		[.declaration(expression)]
	}
}

public extension StatementDescriptor {
	/// Creates a mutable variable declaration.
	///
	/// - Parameters:
	///   - identifier: The variable or constant identifier.
	///   - type: The type reference of the variable or constant.
	///   - expression: An optional initial value expression assigned to the declaration.
	static func `var`(
		_ identifier: String,
		type: TypeReference,
		expression: ExpressionDescriptor? = nil
	) -> StatementDescriptor {
		.declaration(DeclarationStatementDescriptor(
			.var,
			identifier: identifier,
			type: type,
			expression: expression,
		))
	}

	/// Creates an immutable constant declaration.
	///
	/// - Parameters:
	///   - identifier: The variable or constant identifier.
	///   - type: The type reference of the variable or constant.
	///   - expression: An optional initial value expression assigned to the declaration.
	static func `let`(
		_ identifier: String,
		type: TypeReference,
		expression: ExpressionDescriptor? = nil
	) -> StatementDescriptor {
		.declaration(DeclarationStatementDescriptor(
			.let,
			identifier: identifier,
			type: type,
			expression: expression
		))
	}
}

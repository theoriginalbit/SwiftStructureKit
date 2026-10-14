//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An declaration statement that declares a variable or constant.
public struct DeclarationStatementDescriptor: Sendable {
	/// A Boolean value indicating whether the declaration is mutable (`var`) or immutable (`let`).
	public let isMutable: Bool

	/// The variable or constant identifier.
	public let identifier: String

	/// The type reference of the variable or constant.
	public let type: TypeReference

	/// An optional initial value expression assigned to the declaration.
	public let expression: ExpressionDescriptor?

	/// An assignment statement, declaring a variable or constant.
	///
	/// - Parameters:
	///   - isMutable: A Boolean value indicating whether the declaration is mutable (`var`) or immutable (`let`).
	///   - identifier: The variable or constant identifier.
	///   - type: The type reference of the variable or constant.
	///   - expression: An optional initial value expression assigned to the declaration.
	public init(
		isMutable: Bool,
		identifier: String,
		type: TypeReference,
		expression: ExpressionDescriptor? = nil
	) {
		self.isMutable = isMutable
		self.identifier = identifier
		self.type = type
		self.expression = expression
	}
}

extension ArrayBuilder where T == StatementDescriptor {
	public static func buildExpression(_ expression: DeclarationStatementDescriptor) -> Result {
		[.declaration(expression)]
	}
}

public extension StatementDescriptor {
	/// Creates a mutable variable declaration.
	static func `var`(
		_ identifier: String,
		type: TypeReference,
		expression: ExpressionDescriptor? = nil
	) -> StatementDescriptor {
		.declaration(DeclarationStatementDescriptor(
			isMutable: true,
			identifier: identifier,
			type: type,
			expression: expression,
		))
	}

	/// Creates an immutable constant declaration.
	static func `let`(
		_ identifier: String,
		type: TypeReference,
		expression: ExpressionDescriptor? = nil
	) -> StatementDescriptor {
		.declaration(DeclarationStatementDescriptor(
			isMutable: false,
			identifier: identifier,
			type: type,
			expression: expression
		))
	}
}

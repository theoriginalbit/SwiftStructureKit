//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public struct AssignmentStatementDescriptor: Sendable {
	public let target: TypeIdentifier
	public let expression: ExpressionDescriptor

	public init(target: TypeIdentifier, expression: ExpressionDescriptor) {
		self.target = target
		self.expression = expression
	}
}

extension ArrayBuilder where T == StatementDescriptor {
	public static func buildExpression(_ expression: AssignmentStatementDescriptor) -> Result {
		[.assignment(expression)]
	}

	public static func buildExpression(_ expression: ExpressionDescriptor) -> Result {
		[.expression(expression)]
	}
}

public extension StatementDescriptor {
	static func assignment(target: TypeIdentifier, expression: ExpressionDescriptor) -> Self {
		.assignment(AssignmentStatementDescriptor(target: target, expression: expression))
	}
}

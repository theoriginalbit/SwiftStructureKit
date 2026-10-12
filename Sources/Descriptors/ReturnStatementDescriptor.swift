//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A return statement with an optional expression.
public struct ReturnStatementDescriptor {
	public let expression: ExpressionDescriptor?

	public init(_ expression: ExpressionDescriptor? = nil) {
		self.expression = expression
	}
}

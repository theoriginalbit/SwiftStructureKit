//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A return statement with an optional expression.
public struct ReturnStatementDescriptor: Sendable {
	/// The optional expression returned by the statement.
	public let expression: ExpressionDescriptor?

	/// Creates a return statement.
	///
	/// - Parameter expression: The optional expression to return.
	public init(_ expression: ExpressionDescriptor? = nil) {
		self.expression = expression
	}
}

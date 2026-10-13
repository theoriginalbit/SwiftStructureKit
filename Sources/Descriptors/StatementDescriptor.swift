//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor for Swift statements.
public enum StatementDescriptor: Sendable {
	/// A stored or computed property declaration.
	case property(PropertyDescriptor)

	/// An assignment statement, declaring a variable or constant.
	static func assignment(_ descriptor: AssignmentStatementDescriptor) -> Self {
		// syntactically an assignment `var x: Int = 4` or `let y: Bool = false`
		// is the same as a stored property. This helper allows sharing the renderer.
		.property(
			PropertyDescriptor(
				descriptor.identifier,
				comment: nil,
				accessModifier: nil,
				isStatic: false,
				type: descriptor.type,
				kind: .stored(
					isMutable: descriptor.isMutable,
					defaultValue: descriptor.expression,
					observers: []
				)
			)
		)
	}

	/// Not truely a statement, but allows for simple addition to a ``CodeBlockDescriptor``
	case comment(InlineCommentDescriptor)

	/// A `#warning` or `#error` compiler diagnostic directive.
	case diagnostic(DiagnosticDirectiveDescriptor)

	/// A return statement with an optional return expression.
	case `return`(ReturnStatementDescriptor)

	/// A return statement with an optional return expression.
	static func `return`(_ expression: ExpressionDescriptor? = nil) -> Self {
		.return(ReturnStatementDescriptor(expression))
	}
}

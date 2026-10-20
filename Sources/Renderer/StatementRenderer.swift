//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum StatementRenderer {
	static func render(_ statements: [StatementDescriptor], to writer: inout CodeWriter) {
		for statement in statements {
			render(statement, to: &writer)
		}
	}

	static func render(_ statement: StatementDescriptor, to writer: inout CodeWriter) {
		switch statement {
		case let .assignment(descriptor):
			writer.writeLine { line in
				line.token(CodeRenderingSupport.renderedIdentifier(descriptor.target))
				line.punctuation(.equal)
				line.token(ExpressionRenderer.renderedExpression(descriptor.expression))
			}

		case let .expression(expression):
			writer.writeLine { line in
				line.token(ExpressionRenderer.renderedExpression(expression))
			}

		case let .declaration(descriptor):
			PropertyRenderer.render(
				PropertyDescriptor(
					descriptor.identifier,
					type: descriptor.type,
					kind: .stored(descriptor.kind, defaultValue: descriptor.expression)
				),
				to: &writer
			)

		case let .property(descriptor):
			precondition(descriptor.accessModifier == nil, "Local properties cannot have access modifiers.")
			precondition(!descriptor.isStatic, "Local properties cannot be static.")
			PropertyRenderer.render(descriptor, to: &writer)

		case let .comment(descriptor):
			CommentRenderer.renderInlineComment(descriptor, to: &writer)

		case let .diagnostic(descriptor):
			DiagnosticDirectiveRenderer.render(descriptor, to: &writer)

		case let .unaryKeyword(descriptor):
			CodeRenderingSupport.renderUnaryKeyword(descriptor, to: &writer)

		case let .if(descriptor):
			render(descriptor.branches, to: &writer)

		case let .ifElse(descriptor):
			render(descriptor.branches, elseBody: descriptor.elseBody, to: &writer)

		case let .guard(descriptor):
			writer.writeLine { line in
				line.token("guard")
				line.token(ExpressionRenderer.renderedExpression(descriptor.condition))
				line.token("else")
				line.block(descriptor.elseBody)
			}
			render(descriptor.body.statements, to: &writer)
		}
	}

	private static func render(_ branches: [IfStatementDescriptor.Branch], elseBody: CodeBlockDescriptor? = nil, to writer: inout CodeWriter) {
		// The whole chain is one logical line: each block's closing
		// brace is followed by the next `else` on the same physical line.
		writer.writeLine { line in
			for (index, branch) in branches.enumerated() {
				if index > 0 {
					line.token("else")
				}
				line.token("if")
				line.token(ExpressionRenderer.renderedExpression(branch.condition))
				line.block(branch.body)
			}

			if let elseBody {
				line.token("else")
				line.block(elseBody)
			}
		}
	}
}

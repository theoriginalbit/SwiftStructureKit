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
				line.token("=")
				line.token(CodeRenderingSupport.renderedExpression(descriptor.expression))
			}

		case let .expression(expression):
			writer.writeLine { line in
				line.token(CodeRenderingSupport.renderedExpression(expression))
			}

		case let .declaration(descriptor):
			PropertyRenderer.render(
				PropertyDescriptor(
					descriptor.identifier,
					type: descriptor.type,
					kind: .stored(isMutable: descriptor.isMutable, defaultValue: descriptor.expression)
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

		case let .return(descriptor):
			writer.writeLine { line in
				line.token("return")
				if let expression = descriptor.expression {
					line.token(CodeRenderingSupport.renderedExpression(expression))
				}
			}

		case let .if(descriptor):
			render(descriptor.branches, to: &writer)

		case let .ifElse(descriptor):
			render(descriptor.branches, elseBody: descriptor.elseBody, to: &writer)

		case let .guard(descriptor):
			writer.writeLine { line in
				line.token("guard")
				line.token(CodeRenderingSupport.renderedExpression(descriptor.condition))
				line.token("else")
				line.space()
				line.punctuation("{")
			}
			renderContents(descriptor.elseBody, to: &writer)
			writer.writeLine("}")
			StatementRenderer.render(descriptor.body.statements, to: &writer)
		}
	}

	private static func render(_ branches: [IfStatementDescriptor.Branch], elseBody: CodeBlockDescriptor? = nil, to writer: inout CodeWriter) {
		for (index, branch) in branches.enumerated() {
			writer.writeLine { line in
				if index == 0 {
					line.token("if")
				} else {
					line.punctuation("}")
					line.space()
					line.token("else")
					line.token("if")
				}
				line.token(CodeRenderingSupport.renderedExpression(branch.condition))
				line.space()
				line.punctuation("{")
			}
			renderContents(branch.body, to: &writer)
		}

		if let elseBody {
			writer.writeLine { line in
				line.punctuation("}")
				line.space()
				line.token("else")
				line.space()
				line.punctuation("{")
			}
			renderContents(elseBody, to: &writer)
		}
		writer.writeLine("}")
	}

	private static func renderContents(_ body: CodeBlockDescriptor, to writer: inout CodeWriter) {
		writer.indented { writer in
			StatementRenderer.render(body.statements, to: &writer)
		}
	}
}

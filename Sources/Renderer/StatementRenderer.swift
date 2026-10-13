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
				line.token(descriptor.isMutable ? "var" : "let")
				line.token(descriptor.identifier)
				line.punctuation(":")
				line.space()
				line.token(CodeRenderingSupport.renderedType(descriptor.type))
				if let expression = descriptor.expression {
					line.space()
					line.punctuation("=")
					line.space()
					line.token(CodeRenderingSupport.renderedExpression(expression))
				}
			}

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
		}
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderStatements(_ statements: [StatementDescriptor]) {
		renderStatements(statements, to: &writer)
	}

	func renderStatements(_ statements: [StatementDescriptor], to writer: inout CodeFileWriter) {
		for statement in statements {
			renderStatement(statement, to: &writer)
		}
	}

	func renderStatement(_ statement: StatementDescriptor) {
		renderStatement(statement, to: &writer)
	}

	func renderStatement(_ statement: StatementDescriptor, to writer: inout CodeFileWriter) {
		switch statement {
		case let .assignment(descriptor):
			writer.writeLine { line in
				line.token(descriptor.isMutable ? "var" : "let")
				line.token(descriptor.identifier)
				line.punctuation(":")
				line.space()
				line.token(renderedType(descriptor.type))
				if let expression = descriptor.expression {
					line.space()
					line.punctuation("=")
					line.space()
					line.token(renderedExpression(expression))
				}
			}

		case let .comment(descriptor):
			renderInlineComment(descriptor, to: &writer)

		case let .diagnostic(descriptor):
			renderDiagnosticDirective(descriptor, to: &writer)

		case let .return(expression):
			writer.writeLine { line in
				line.token("return")
				if let expression {
					line.token(renderedExpression(expression))
				}
			}
		}
	}
}

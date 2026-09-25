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
		writer.writeLine { line in
			switch statement.kind {
			case let .assignment(isMutable, identifier, type, expression):
				line.token(isMutable ? "var" : "let")
				line.token(identifier)
				line.punctuation(":")
				line.space()
				line.token(renderedType(type))
				if let expression {
					line.space()
					line.punctuation("=")
					line.space()
					line.token(renderedExpression(expression))
				}
			case let .return(expression):
				line.token("return")
				if let expression {
					line.token(renderedExpression(expression))
				}
			}
		}
	}
}

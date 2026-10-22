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
			renderAssignment(descriptor, to: &writer)

		case let .expression(expression):
			writer.writeLine { line in ExpressionRenderer.render(expression, to: &line) }

		case let .declaration(descriptor):
			renderDeclaration(descriptor, to: &writer)

		case let .property(descriptor):
			precondition(descriptor.accessModifier == nil, "Local properties cannot have access modifiers.")
			precondition(!descriptor.isStatic, "Local properties cannot be static.")
			PropertyRenderer.render(descriptor, to: &writer)

		case let .comment(descriptor):
			CommentRenderer.renderInlineComment(descriptor, to: &writer)

		case let .diagnostic(descriptor):
			DiagnosticDirectiveRenderer.render(descriptor, to: &writer)

		case let .controlFlow(descriptor):
			renderControlFlow(descriptor, to: &writer)

		case let .conditional(descriptor):
			renderConditional(descriptor, to: &writer)

		case let .labeled(descriptor):
			renderLabeled(descriptor, to: &writer)
		}
	}

	private static func renderAssignment(_ descriptor: AssignmentStatementDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			ExpressionRenderer.render(descriptor.left, to: &line)
			line.punctuation(.assign)
			ExpressionRenderer.render(descriptor.right, to: &line)
		}
	}

	private static func renderDeclaration(_ descriptor: DeclarationStatementDescriptor, to writer: inout CodeWriter) {
		PropertyRenderer.render(
			PropertyDescriptor(
				descriptor.identifier,
				type: descriptor.type,
				kind: .stored(descriptor.kind, defaultValue: descriptor.expression)
			),
			to: &writer
		)
	}

	private static func renderControlFlow(_ descriptor: ControlFlowDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			switch descriptor {
			case let .return(expression):
				line.token("return")
				if let expression {
					ExpressionRenderer.render(expression, to: &line)
				}
			case let .throw(expression):
				line.token("throw")
				ExpressionRenderer.render(expression, to: &line)
			case let .continue(label):
				line.token("continue")
				if let label {
					line.token(label)
				}
			case let .break(label):
				line.token("break")
				if let label {
					line.token(label)
				}
			case .fallthrough:
				line.token("fallthrough")
			}
		}
	}

	private static func renderConditional(_ descriptor: ConditionalStatementDescriptor, to writer: inout CodeWriter) {
		switch descriptor {
		case let .if(descriptor):
			renderIfConditional(descriptor.branches, to: &writer)

		case let .ifElse(descriptor):
			renderIfConditional(descriptor.branches, elseBody: descriptor.elseBody, to: &writer)

		case let .guard(descriptor):
			writer.writeLine { line in
				line.token("guard")
				ExpressionRenderer.render(descriptor.condition, to: &line)
				line.token("else")
				line.block(descriptor.elseBody)
			}
		}
	}

	private static func renderIfConditional(
		_ branches: [IfStatementDescriptor.Branch],
		elseBody: CodeBlockDescriptor? = nil,
		label: String? = nil,
		to writer: inout CodeWriter
	) {
		// The whole chain is one logical line: each block's closing
		// brace is followed by the next `else` on the same physical line.
		writer.writeLine { line in
			if let label {
				line.token(label)
				line.punctuation(.colon)
			}

			for (index, branch) in branches.enumerated() {
				if index > 0 {
					line.token("else")
				}
				line.token("if")
				ExpressionRenderer.render(branch.condition, to: &line)
				line.block(branch.body)
			}

			if let elseBody {
				line.token("else")
				line.block(elseBody)
			}
		}
	}

	private static func renderLabeled(_ descriptor: LabeledStatementDescriptor, to writer: inout CodeWriter) {
		let label = SwiftIdentifier.sanitized(descriptor.label)
		switch descriptor.statement {
		case let .if(descriptor):
			renderIfConditional(descriptor.branches, label: label, to: &writer)
		case let .ifElse(descriptor):
			renderIfConditional(descriptor.branches, elseBody: descriptor.elseBody, label: label, to: &writer)
		}
	}
}

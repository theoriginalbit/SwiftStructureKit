//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ExpressionRenderer {
	static func render(_ expression: ExpressionDescriptor, to writer: inout LineWriter) {
		switch expression {
		case let .literal(literal):
			writer.token(CodeRenderingSupport.renderedLiteral(literal))

		case let .raw(value):
			writer.token(value)

		case let .functionCall(descriptor):
			renderFunctionCall(descriptor, to: &writer)

		case let .memberAccess(descriptor):
			renderMemberAccess(descriptor, to: &writer)

		case let .inOut(expression):
			writer.punctuation(.Prefix.ampersand)
			render(expression, to: &writer)

		case let .identifier(identifier):
			writer.token(CodeRenderingSupport.renderedIdentifier(identifier))

		case let .tuple(descriptors):
			renderTuple(descriptors, to: &writer)

		case let .if(descriptor):
			renderCondition(descriptor.branches, to: &writer)

		case let .ifElse(descriptor):
			renderCondition(descriptor.branches, elseBody: descriptor.elseBody, to: &writer)

		case let .try(hasPostfixQuestionMark, expression):
			renderTry(hasPostfixQuestionMark, expression, to: &writer)

		case let .await(expression):
			renderAwait(expression, to: &writer)
		}
	}

	private static func renderFunctionCall(_ descriptor: FunctionCallDescriptor, to writer: inout LineWriter) {
		render(descriptor.calledExpression, to: &writer)
		writer.punctuation(.leftParen)

		var iterator = descriptor.arguments.makeIterator()
		if let first = iterator.next() {
			renderArgument(first, to: &writer)
			while let next = iterator.next() {
				writer.punctuation(.comma)
				renderArgument(next, to: &writer)
			}
		}
		writer.punctuation(.rightParen)
	}

	private static func renderArgument(_ argument: Argument, to writer: inout LineWriter) {
		if let label = argument.label {
			writer.token(SwiftIdentifier.sanitized(label, position: .argumentLabel))
			writer.punctuation(.colon)
		}
		render(argument.value, to: &writer)
	}

	private static func renderMemberAccess(_ descriptor: MemberAccessDescriptor, to writer: inout LineWriter) {
		if let left = descriptor.left {
			render(left, to: &writer)
			writer.punctuation(.period)
		} else {
			writer.punctuation(.Prefix.period)
		}
		writer.token(SwiftIdentifier.sanitized(descriptor.right, position: .memberAccess))
	}

	private static func renderTuple(_ descriptors: [ExpressionDescriptor], to writer: inout LineWriter) {
		writer.punctuation(.leftParen)
		var iterator = descriptors.makeIterator()
		if let first = iterator.next() {
			render(first, to: &writer)
			while let next = iterator.next() {
				writer.punctuation(.comma)
				render(next, to: &writer)
			}
		}
		writer.punctuation(.rightParen)
	}

	private static func renderCondition(_ branches: [IfExpressionDescriptor.Branch], elseBody: ExpressionDescriptor? = nil, to writer: inout LineWriter) {
		// The whole chain is one logical line: each block's closing
		// brace is followed by the next `else` on the same physical line.
		for (index, branch) in branches.enumerated() {
			if index > 0 {
				writer.token("else")
			}
			writer.token("if")
			render(branch.condition, to: &writer)
			writer.block { writer in
				writer.writeLine { line in
					render(branch.body, to: &line)
				}
			}
		}

		if let elseBody {
			writer.token("else")
			writer.block { writer in
				writer.writeLine { line in
					render(elseBody, to: &line)
				}
			}
		}
	}

	private static func renderTry(_ hasPostfixQuestionMark: Bool, _ expression: ExpressionDescriptor, to writer: inout LineWriter) {
		writer.token("try")
		if hasPostfixQuestionMark {
			writer.punctuation(.Postfix.questionMark)
		}
		render(expression, to: &writer)
	}

	private static func renderAwait(_ expression: ExpressionDescriptor, to writer: inout LineWriter) {
		writer.token("await")
		render(expression, to: &writer)
	}
}

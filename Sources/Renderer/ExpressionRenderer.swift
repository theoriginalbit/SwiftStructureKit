//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ExpressionRenderer {
	static func renderedExpression(_ expression: ExpressionDescriptor) -> String {
		switch expression {
		case let .literal(literal):
			return CodeRenderingSupport.renderedLiteral(literal)

		case let .raw(value):
			return value

		case let .functionCall(descriptor):
			return renderedFunctionCall(descriptor)

		case let .memberAccess(descriptor):
			return renderedMemberAccess(descriptor)

		case let .identifier(identifier):
			return CodeRenderingSupport.renderedIdentifier(identifier)
		}
	}

	private static func renderedFunctionCall(_ descriptor: FunctionCallDescriptor) -> String {
		var writer = TokenWriter()
		writer.write(renderedExpression(descriptor.calledExpression))
		writer.write(.leftParen)

		var iterator = descriptor.arguments.makeIterator()
		if let first = iterator.next() {
			renderArgument(first, into: &writer)
			while let next = iterator.next() {
				writer.write(.comma)
				renderArgument(next, into: &writer)
			}
		}

		writer.write(.rightParen)
		return writer.finish()
	}

	private static func renderArgument(_ argument: Argument, into writer: inout TokenWriter) {
		if let label = argument.label {
			writer.write(SwiftIdentifier.sanitized(label, position: .argumentLabel))
			writer.write(.colon)
		}
		writer.write(renderedExpression(argument.value))
	}

	private static func renderedMemberAccess(_ descriptor: MemberAccessDescriptor) -> String {
		var writer = TokenWriter()
		if let left = descriptor.left {
			writer.write(renderedExpression(left))
		}
		writer.write(.period)
		writer.write(SwiftIdentifier.sanitized(descriptor.right, position: .memberAccess))
		return writer.finish()
	}
}

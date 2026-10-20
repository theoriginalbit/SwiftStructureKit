//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ExpressionRenderer {
	static func rendered(_ expression: ExpressionDescriptor) -> String {
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

		case let .tuple(descriptors):
			return renderedTuple(descriptors)
		}
	}

	private static func renderedFunctionCall(_ descriptor: FunctionCallDescriptor) -> String {
		var writer = TokenWriter()
		writer.write(rendered(descriptor.calledExpression))
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
		writer.write(rendered(argument.value))
	}

	private static func renderedMemberAccess(_ descriptor: MemberAccessDescriptor) -> String {
		var writer = TokenWriter()
		if let left = descriptor.left {
			writer.write(rendered(left))
		}
		writer.write(.period)
		writer.write(SwiftIdentifier.sanitized(descriptor.right, position: .memberAccess))
		return writer.finish()
	}

	private static func renderedTuple(_ descriptors: [ExpressionDescriptor]) -> String {
		var writer = TokenWriter()
		writer.write(.leftParen)
		var iterator = descriptors.makeIterator()
		if let first = iterator.next() {
			writer.write(rendered(first))
			while let next = iterator.next() {
				writer.write(.comma)
				writer.write(rendered(next))
			}
		}
		writer.write(.rightParen)
		return writer.finish()
	}
}

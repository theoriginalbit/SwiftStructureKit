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

		case let .identifier(identifier):
			writer.token(CodeRenderingSupport.renderedIdentifier(identifier))

		case let .tuple(descriptors):
			renderTuple(descriptors, to: &writer)

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
		} else {
			// force a space when there was no left expression since `.` doesn't
			// allow space before it. If we accept a space before this token we end
			// up with a double space.
			writer.token(" ", acceptsSpaceBefore: false)
		}
		writer.punctuation(.period)
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
}

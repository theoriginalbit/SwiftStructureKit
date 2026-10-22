//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct ExpressionRendererTests {
	@Test func ifElseExpression() {
		let input = ExpressionDescriptor.if(
			.raw("value > 0"),
			.literal(.integer(1))
		).elseIf(
			.raw("value < 0"),
			body: .literal(.integer(-1))
		).else(
			body: .literal(.integer(0))
		)
		let output = RenderTest.renderLine { writer in
			ExpressionRenderer.render(.ifElse(input), to: &writer)
		}

		expectRendered(output, equals: """
			if value > 0 {
				1
			} else if value < 0 {
				-1
			} else {
				0
			}

			""")
	}

	@Test func ifExpressionUsesConfiguredIndentation() {

		let input = ExpressionDescriptor.if(
			.identifier("isEnabled"),
			.literal(.integer(1)),
			else: .literal(.integer(2)),
		)
		let output = RenderTest.renderLine { writer in
			ExpressionRenderer.render(input, to: &writer)
		}

		expectRendered(output, equals: """
			if isEnabled {
				1
			} else {
				2
			}

			""")
	}

	@Test func `composing try await with control flow`() {
		let input = StatementDescriptor.return(
			.try(.await(.functionCall("fn")))
		)
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		expectRendered(output, equals: """
			return try await fn()

			""")
	}

	@Test func `optional try`() {
		let input = ExpressionDescriptor.try(hasPostfixQuestionMark: true, .functionCall("fn"))
		let output = RenderTest.renderLine { writer in
			ExpressionRenderer.render(input, to: &writer)
		}
		expectRendered(output, equals: """
			try? fn()

			""")
	}

	@Test func inOut() {
		let input = ExpressionDescriptor.inOut(.identifier("writer"))
		let output = RenderTest.renderLine { writer in
			ExpressionRenderer.render(input, to: &writer)
		}
		expectRendered(output, equals: """
			&writer

			""")
	}
}

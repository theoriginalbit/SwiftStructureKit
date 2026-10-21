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
			.literal(.boolean(true))
		)
		let output = RenderTest.renderLine { writer in
			ExpressionRenderer.render(.if(input), to: &writer)
		}

		expectRendered(output, equals: """
			if isEnabled {
				true
			}

			""")
	}
}

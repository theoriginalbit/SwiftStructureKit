//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct StatementRendererTests {
	// MARK: - Assignment

	@Test func varDeclaration() {
		let input = StatementDescriptor.var("test", type: .optional(.string))
		let output = RenderTest.render { renderer in
			renderer.renderStatement(input)
		}
		#expect(output == "var test: Optional<String>\n")
	}

	@Test func varStatement() {
		let input = StatementDescriptor.var("test", type: .int, expression: .literal(.integer(123)))
		let output = RenderTest.render { renderer in
			renderer.renderStatement(input)
		}
		#expect(output == "var test: Int = 123\n")
	}

	@Test func letDeclaration() {
		let input = StatementDescriptor.let("test", type: .optional(.string))
		let output = RenderTest.render { renderer in
			renderer.renderStatement(input)
		}
		#expect(output == "let test: Optional<String>\n")
	}

	@Test func letStatement() {
		let input = StatementDescriptor.let("test", type: .int, expression: .literal(.integer(123)))
		let output = RenderTest.render { renderer in
			renderer.renderStatement(input)
		}
		#expect(output == "let test: Int = 123\n")
	}

	// MARK: - Return

	@Test func renderJustReturn() {
		let input = StatementDescriptor.return()
		let output = RenderTest.render { renderer in
			renderer.renderStatement(input)
		}
		#expect(output == "return\n")
    }

	@Test func renderReturnWithValue() {
		let input = StatementDescriptor.return(.literal(.integer(123)))
		let output = RenderTest.render { renderer in
			renderer.renderStatement(input)
		}
		#expect(output == "return 123\n")
	}
}

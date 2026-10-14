//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct StatementRendererTests {
	// MARK: - Assignment

	@Test func varDeclaration() {
		let input = StatementDescriptor.var("test", type: .optional(.string))
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		#expect(output == "var test: Optional<String>\n")
	}

	@Test func varStatement() {
		let input = StatementDescriptor.var("test", type: .int, expression: .literal(.integer(123)))
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		#expect(output == "var test: Int = 123\n")
	}

	@Test func letDeclaration() {
		let input = StatementDescriptor.let("test", type: .optional(.string))
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		#expect(output == "let test: Optional<String>\n")
	}

	@Test func letStatement() {
		let input = StatementDescriptor.let("test", type: .int, expression: .literal(.integer(123)))
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		#expect(output == "let test: Int = 123\n")
	}

	@Test func storedAndComputedProperties() {
		let statements = CodeBlockDescriptor {
			PropertyDescriptor.var(
				"stored",
				type: .int,
				defaultValue: .literal(.integer(1)),
			)
			PropertyDescriptor.computed("computed", type: .int) {
				StatementDescriptor.return(.literal(.integer(2)))
			}
		}
		let output = RenderTest.render { writer in
			StatementRenderer.render(statements.statements, to: &writer)
		}

		#expect(output == """
			var stored: Int = 1
			var computed: Int {
			    get {
			        return 2
			    }
			}

			""")
	}

	@Test func localPropertyWithAccessModifierExits() async {
		await #expect(processExitsWith: .failure) {
			let property = PropertyDescriptor.var(
				"invalid",
				accessModifier: .private,
				type: .int,
			)
			var writer = CodeWriter()
			StatementRenderer.render(.property(property), to: &writer)
		}
	}

	@Test func localStaticPropertyExits() async {
		await #expect(processExitsWith: .failure) {
			let property = PropertyDescriptor.var(
				"invalid",
				isStatic: true,
				type: .int,
			)
			var writer = CodeWriter()
			StatementRenderer.render(.property(property), to: &writer)
		}
	}

	// MARK: - Return

	@Test func renderJustReturn() {
		let input = StatementDescriptor.return()
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		#expect(output == "return\n")
    }

	@Test func renderReturnWithValue() {
		let input = StatementDescriptor.return(.literal(.integer(123)))
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		#expect(output == "return 123\n")
	}

	// MARK: - Conditional statements

	@Test func ifElseIfElse() {
		let block = CodeBlockDescriptor {
			StatementDescriptor.if(.raw("value > 0")) {
				StatementDescriptor.return(.literal(.integer(1)))
			}
			.elseIf(.raw("value < 0")) {
				StatementDescriptor.return(.literal(.integer(-1)))
			}
			.else {
				StatementDescriptor.return(.literal(.integer(0)))
			}
		}
		let output = RenderTest.render { writer in
			StatementRenderer.render(block.statements, to: &writer)
		}

		#expect(output == """
			if value > 0 {
			    return 1
			} else if value < 0 {
			    return -1
			} else {
			    return 0
			}

			""")
	}

	@Test func ifWithoutElse() {
		let block = CodeBlockDescriptor {
			StatementDescriptor.if(.raw("isEnabled")) {
				StatementDescriptor.return()
			}
		}
		let output = RenderTest.render { writer in
			StatementRenderer.render(block.statements, to: &writer)
		}

		#expect(output == """
			if isEnabled {
			    return
			}

			""")
	}

	@Test func guardWithContinuation() {
		let block = CodeBlockDescriptor {
			StatementDescriptor.guard(.raw("isValid")) {
				StatementDescriptor.return(.raw("value"))
			} else: {
				StatementDescriptor.return()
			}
		}
		let output = RenderTest.render { writer in
			StatementRenderer.render(block.statements, to: &writer)
		}

		#expect(output == """
			guard isValid else {
			    return
			}
			return value

			""")
	}
}

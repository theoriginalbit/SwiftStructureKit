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
		expectRendered(output, equals: "var test: Optional<String>\n")
	}

	@Test func varStatement() {
		let input = StatementDescriptor.var("test", type: .int, expression: .literal(.integer(123)))
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		expectRendered(output, equals: "var test: Int = 123\n")
	}

	@Test func letDeclaration() {
		let input = StatementDescriptor.let("test", type: .optional(.string))
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		expectRendered(output, equals: "let test: Optional<String>\n")
	}

	@Test func letStatement() {
		let input = StatementDescriptor.let("test", type: .int, expression: .literal(.integer(123)))
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		expectRendered(output, equals: "let test: Int = 123\n")
	}

	@Test func assignmentStatement() {
		let input = StatementDescriptor.assignment(
			.selfMember("name"),
			.identifier("name"),
		)
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}

		expectRendered(output, equals: "self.name = name\n")
	}

	@Test func assignmentIfExpression() {
		let input = StatementDescriptor.assignment(
			.memberAccess("self", "name"),
			.if(.memberAccess("name", "isEmpty"), .literal(.string("User")), else: .identifier("name")),
		)
		let output = RenderTest.render(indentUsing: .tabs) { writer in
			StatementRenderer.render(input, to: &writer)
		}

		expectRendered(output, equals: """
			self.name = if name.isEmpty {
				"User"
			} else {
				name
			}
			
			""")
	}

	@Test func assignmentWithFunctionCallExpression() {
		let input = StatementDescriptor.assignment(
			"self.descriptor",
			.functionCall(
				"TypealiasDescriptor",
				[
					.init(value: .raw("name")),
					.init(label: "attributes", value: .raw("attributes")),
					.init(label: "assignedType", value: .raw("assignedType")),
				],
			),
		)
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}

		expectRendered(output, equals: "self.descriptor = TypealiasDescriptor(name, attributes: attributes, assignedType: assignedType)\n")
	}

	@Test func expressionStatementWithNestedFunctionCall() {
		let block = CodeBlockDescriptor {
			ExpressionDescriptor.functionCall(
				"self.init",
				ArgumentsList {
					Argument(value: .identifier("identifier"))
					Argument(label: "comment", value: .raw("comment"))
					Argument(label: "members", value: .functionCall("members"))
				}
			)
			StatementDescriptor.assignment(
				"self.kind",
				.functionCall(
					"Kind.conformsTo",
					ArgumentsList([
						.init(
							value: .functionCall(
								"TypeComposition",
								[.init(value: .raw("other"))],
							),
						),
					]),
				),
			)
		}
		let output = RenderTest.render { writer in
			StatementRenderer.render(block.statements, to: &writer)
		}

		expectRendered(output, equals: """
			self.init(identifier, comment: comment, members: members())
			self.kind = Kind.conformsTo(TypeComposition(other))

			""")
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

		expectRendered(output, equals: """
			var stored: Int = 1
			var computed: Int {
			    return 2
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
			var writer = CodeWriter(indentUsing: .spaces(4))
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
			var writer = CodeWriter(indentUsing: .spaces(4))
			StatementRenderer.render(.property(property), to: &writer)
		}
	}

	// MARK: - Return

	@Test func renderJustReturn() {
		let input = StatementDescriptor.return()
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		expectRendered(output, equals: "return\n")
    }

	@Test func renderReturnWithValue() {
		let input = StatementDescriptor.return(.literal(.integer(123)))
		let output = RenderTest.render { writer in
			StatementRenderer.render(input, to: &writer)
		}
		expectRendered(output, equals: "return 123\n")
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

		expectRendered(output, equals: """
			if value > 0 {
			    return 1
			} else if value < 0 {
			    return -1
			} else {
			    return 0
			}

			""")
	}

	@Test func ifWithElse() {
		let block = CodeBlockDescriptor {
			StatementDescriptor.if(.raw("isEnabled")) {
				StatementDescriptor.return()
			} else: {
				StatementDescriptor.expression(.functionCall("performWork"))
			}
		}
		let output = RenderTest.render(indentUsing: .tabs) { writer in
			StatementRenderer.render(block.statements, to: &writer)
		}

		expectRendered(output, equals: """
			if isEnabled {
				return
			} else {
				performWork()
			}

			""")
	}

	@Test func ifWithoutElse() {
		let block = CodeBlockDescriptor {
			StatementDescriptor.if(.identifier("isEnabled")) {
				StatementDescriptor.return()
			}
		}
		let output = RenderTest.render(indentUsing: .tabs) { writer in
			StatementRenderer.render(block.statements, to: &writer)
		}

		expectRendered(output, equals: """
			if isEnabled {
				return
			}

			""")
	}

	@Test func guardWithContinuation() {
		let block = CodeBlockDescriptor {
			StatementDescriptor.guard(.identifier("isValid")) {
				StatementDescriptor.return()
			}
			StatementDescriptor.return(.raw("value"))
		}
		let output = RenderTest.render { writer in
			StatementRenderer.render(block.statements, to: &writer)
		}

		expectRendered(output, equals: """
			guard isValid else {
			    return
			}
			return value

			""")
	}

	// MARK: - Labeled statements

	@Test func labeledIf() {
		let block = CodeBlockDescriptor {
			StatementDescriptor.if(.identifier("isEnabled")) {
				StatementDescriptor.return()
			}
			.labeled("outer")
		}
		let output = RenderTest.render(indentUsing: .tabs) { writer in
			StatementRenderer.render(block.statements, to: &writer)
		}

		expectRendered(output, equals: """
			outer: if isEnabled {
				return
			}

			""")
	}

	@Test func labeledIfElseIfElse() {
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
			.labeled("check")
		}
		let output = RenderTest.render(indentUsing: .tabs) { writer in
			StatementRenderer.render(block.statements, to: &writer)
		}

		expectRendered(output, equals: """
			check: if value > 0 {
				return 1
			} else if value < 0 {
				return -1
			} else {
				return 0
			}

			""")
	}
}

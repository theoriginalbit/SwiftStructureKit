//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct ClassRendererTests {
	@Test("Render basic empty class") func renderEmptyClass() {
		let descriptor = ClassDescriptor("Simple")
		let output = RenderTest.render { writer in
			ClassRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			class Simple {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("Render with attributes, modifiers, generics, and conformances")
	func renderClassWithMore() {
		let descriptor = ClassDescriptor(
			"WithMore",
			accessModifier: .open,
			attributes: [.mainActor, .available("iOS 17, *")],
			genericParameters: ["T", "U"],
			conformances: [.sendable, .equatable],
		)
		let output = RenderTest.render { writer in
			ClassRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			@MainActor
			@available(iOS 17, *)
			open class WithMore<T, U>: Sendable, Equatable {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("Render generic parameter constraints and where requirements")
	func renderGenericConstraints() {
		let descriptor = ClassDescriptor(
			"F",
			genericParameters: ["T", "N"],
			genericRequirements: [
				TypeConstraintDescriptor("T", conformsTo: .equatable)
			]
		)
		let output = RenderTest.render { writer in
			ClassRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			class F<T, N> where T: Equatable {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("Render class with doc comment")
	func renderWithDocComment() {
		let descriptor = ClassDescriptor(
			"UserModel",
			comment: """
			A user model.

			Replicates the server model.
			""",
			isFinal: true,
		)
		let output = RenderTest.render { writer in
			ClassRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			/// A user model.
			///
			/// Replicates the server model.
			final class UserModel {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("Render struct with members")
	func renderStructWithMembers() {
		let descriptor = ClassDescriptor("User") {
			DeclarationDescriptor.initializer(
				accessModifier: .public,
				failable: false,
				parameters: [.init("id", type: .string)]
			) {}
			DeclarationDescriptor.function(
				comment: "Gets the identifier.",
				accessModifier: .public,
				name: "getIdentifier",
				returns: .string,
			) {
				StatementDescriptor.return(.literal(.string("123")))
			}
		}
		let output = RenderTest.render { writer in
			ClassRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			class User {
			    public init(id: String) {}

			    /// Gets the identifier.
			    public func getIdentifier() -> String {
			        return "123"
			    }
			}

			"""
		expectRendered(output, equals: expected)
	}
}

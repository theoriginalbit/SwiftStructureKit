//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct StructRendererTests {
	@Test("Render basic empty struct")
	func renderBasicEmptyStruct() {
		let structDescriptor = StructDescriptor("SimpleStruct") {}
		let output = RenderTest.render { writer in
			StructRenderer.render(structDescriptor, to: &writer)
		}
		let expected = """
			struct SimpleStruct {}

			"""
		#expect(output == expected)
	}

	@Test("Render struct with access modifier, generic types, and conformances")
	func renderComplexStructHeader() {
		let structDescriptor = StructDescriptor(
			"GenericContainer",
			accessModifier: .public,
			attributes: [.mainActor, .frozen, .available("iOS 17, *")],
			genericParameters: ["T", "U"],
			conformances: [.sendable, .equatable],
		) {}
		let output = RenderTest.render { writer in
			StructRenderer.render(structDescriptor, to: &writer)
		}
		let expected = """
			@MainActor
			@frozen
			@available(iOS 17, *)
			public struct GenericContainer<T, U>: Sendable, Equatable {}

			"""
		#expect(output == expected)
	}

	@Test("Render generic parameter constraints and where requirements")
	func renderGenericConstraints() {
		let structDescriptor = StructDescriptor(
			"F",
			genericParameters: ["T", "N"],
			genericRequirements: [
				TypeConstraintDescriptor("T", conformsTo: .equatable)
			]
		) {}
		let output = RenderTest.render { writer in
			StructRenderer.render(structDescriptor, to: &writer)
		}

		#expect(output == """
			struct F<T, N> where T: Equatable {}

			""")
	}

	@Test("Render struct with doc comment")
	func renderStructWithDocComment() {
		let structDescriptor = StructDescriptor(
			"UserModel",
			comment: "A user model.\n\nReplicates the server model.",
		) {}
		let output = RenderTest.render { writer in
			StructRenderer.render(structDescriptor, to: &writer)
		}
		let expected = """
			/// A user model.
			///
			/// Replicates the server model.
			struct UserModel {}

			"""
		#expect(output == expected)
	}

	@Test("Render struct with members")
	func renderStructWithMembers() {
		let structDescriptor = StructDescriptor("User") {
			TypeMemberDescriptor.initializer(
				accessModifier: .public,
				failable: false,
				parameters: [.init("id", type: .string)]
			) {}
			TypeMemberDescriptor.function(
				comment: "Gets the identifier.",
				accessModifier: .public,
				name: "getIdentifier",
				returns: .string,
			) {
				StatementDescriptor.return(.literal(.string("123")))
			}
		}
		let output = RenderTest.render { writer in
			StructRenderer.render(structDescriptor, to: &writer)
		}
		let expected = """
			struct User {
			    public init(id: String) {}
			
			    /// Gets the identifier.
			    public func getIdentifier() -> String {
			        return "123"
			    }
			}

			"""
		#expect(output == expected)
	}
}

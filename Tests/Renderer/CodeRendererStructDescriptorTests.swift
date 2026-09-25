//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration, .renderer))
struct CodeRendererStructDescriptorTests {

	@Test("Render basic empty struct")
	func renderBasicEmptyStruct() {
		let structDescriptor = StructDescriptor(
			"SimpleStruct",
			members: []
		)
		let output = RenderTest.render { renderer in
			renderer.renderStruct(structDescriptor)
		}
		let expected = """
			struct SimpleStruct {
			}

			"""
		#expect(output == expected)
	}

	@Test("Render struct with access modifier, generic types, and conformances")
	func renderComplexStructHeader() {
		let structDescriptor = StructDescriptor(
			"GenericContainer",
			accessModifier: .public,
			genericTypes: [.type("T"), .type("U")],
			conformances: [.type("Sendable"), .type("Equatable")],
			members: []
		)
		let output = RenderTest.render { renderer in
			renderer.renderStruct(structDescriptor)
		}
		let expected = """
			public struct GenericContainer<T, U>: Sendable, Equatable {
			}

			"""
		#expect(output == expected)
	}

	@Test("Render struct with doc comment")
	func renderStructWithDocComment() {
		let structDescriptor = StructDescriptor(
			"UserModel",
			comment: "A user model.\n\nReplicates the server model.",
			members: []
		)
		let output = RenderTest.render { renderer in
			renderer.renderStruct(structDescriptor)
		}
		let expected = """
			/// A user model.
			/// 
			/// Replicates the server model.
			struct UserModel {
			}

			"""
		#expect(output == expected)
	}

	@Test("Render struct with members")
	func renderStructWithMembers() {
		let structDescriptor = StructDescriptor("User") {
			TypeMemberDescriptor.initializer(
				accessModifier: .public,
				failable: false,
				parameters: [.init("id", type: "String")],
				body: {},
			)
			TypeMemberDescriptor.function(
				comment: "Gets the identifier.",
				accessModifier: .public,
				name: "getIdentifier",
				returns: .type("String")
			) {
				StatementDescriptor.return(.literal(.string("123")))
			}
		}
		let output = RenderTest.render { renderer in
			renderer.renderStruct(structDescriptor)
		}
		let expected = """
			struct User {
			    public init(id: String) {
			    }
			
			    /// Gets the identifier.
			    public func getIdentifier() -> String {
			        return "123"
			    }
			}

			"""
		#expect(output == expected)
	}
}

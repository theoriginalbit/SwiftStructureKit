//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration, .renderer))
struct CodeRendererEnumDescriptorTests {

	@Test("Render uninhabited enum")
	func renderUninhabitedEnum() {
		let enumDescriptor = EnumDescriptor<PlainEnumMode>(
			identifier: "Direction",
			cases: {}
		)
		let output = RenderTest.render { renderer in
			renderer.renderEnum(enumDescriptor)
		}
		let expected = """
			enum Direction {
			}

			"""
		#expect(output == expected)
	}

	@Test("Render complex enum header with access modifier, generic types, and conformances")
	func renderComplexEnumHeader() {
		let enumDescriptor = EnumDescriptor<PlainEnumMode>(
			accessModifier: .public,
			identifier: "Result",
			genericTypes: [.identifier("Success"), .identifier("Failure")],
			conformances: [.sendable],
			cases: {}
		)
		let output = RenderTest.render { renderer in
			renderer.renderEnum(enumDescriptor)
		}
		let expected = """
			public enum Result<Success, Failure>: Sendable {
			}

			"""
		#expect(output == expected)
	}

	@Test("Render plain enum with cases and doc comments")
	func renderPlainEnumWithCases() {
		let enumDescriptor = PlainEnum(
			comment: "A compass direction.",
			identifier: "CompassDirection"
		) {
			PlainEnumCase("north", comment: "Heading north.")
			PlainEnumCase("south")
			PlainEnumCase("east")
			"west"
		}
		let output = RenderTest.render { renderer in
			renderer.renderEnum(enumDescriptor)
		}
		let expected = """
			/// A compass direction.
			enum CompassDirection {
			    /// Heading north.
			    case north
			    case south
			    case east
			    case west
			}

			"""
		#expect(output == expected)
	}

	@Test("Render raw value enum with explicit and implicit raw values")
	func renderRawValueEnum() {
		let enumDescriptor = RawValueEnum<String>(
			accessModifier: .public,
			identifier: "HTTPMethod",
			conformances: [.string]
		) {
			RawValueEnumCase("get", rawValue: .string("GET"))
			RawValueEnumCase("post", rawValue: .string("POST"))
			RawValueEnumCase("custom")
		}
		let output = RenderTest.render { renderer in
			renderer.renderEnum(enumDescriptor)
		}
		let expected = """
			public enum HTTPMethod: String {
			    case get = "GET"
			    case post = "POST"
			    case custom
			}

			"""
		#expect(output == expected)
	}

	@Test("Render raw value enum with integer raw values")
	func renderIntegerRawValueEnum() {
		let enumDescriptor = RawValueEnum<Int>(
			identifier: "StatusCode",
			conformances: [.int]
		) {
			RawValueEnumCase("ok", rawValue: .integer(200))
			RawValueEnumCase("notFound", rawValue: .integer(404))
		}
		let output = RenderTest.render { renderer in
			renderer.renderEnum(enumDescriptor)
		}
		let expected = """
			enum StatusCode: Int {
			    case ok = 200
			    case notFound = 404
			}

			"""
		#expect(output == expected)
	}

	@Test("Render associated value enum with labeled and unlabeled values")
	func renderAssociatedValueEnum() {
		let enumDescriptor = AssociatedValueEnum(
			identifier: "NetworkState"
		) {
			"idle"
			AssociatedValueEnumCase(
				"loading",
				associatedValues: [.init(label: "progress", type: .double)]
			)
			AssociatedValueEnumCase(
				"success",
				associatedValues: [.init(label: "data", type: .identifier("Data")), .init(type: .string)]
			)
			AssociatedValueEnumCase(
				"failure",
				associatedValues: [.init(type: .identifier("Error"))]
			)
		}
		let output = RenderTest.render { renderer in
			renderer.renderEnum(enumDescriptor)
		}
		let expected = """
			enum NetworkState {
			    case idle
			    case loading(progress: Double)
			    case success(data: Data, String)
			    case failure(Error)
			}

			"""
		#expect(output == expected)
	}

	@Test("Render enum with cases and members")
	func renderEnumWithCasesAndMembers() {
		let enumDescriptor = PlainEnum(
			accessModifier: .public,
			identifier: "State",
			cases: {
				PlainEnumCase("active")
				PlainEnumCase("inactive")
			},
			members: {
				TypeMemberDescriptor.function(
					accessModifier: .public,
					name: "toggle",
					returns: .identifier("State")
				) {
					StatementDescriptor.return(.literal(.nil))
				}
			}
		)
		let output = RenderTest.render { renderer in
			renderer.renderEnum(enumDescriptor)
		}
		let expected = """
			public enum State {
			    case active
			    case inactive

			    public func toggle() -> State {
			        return nil
			    }
			}

			"""
		#expect(output == expected)
	}

	@Test("Render associated value enum with labeled and unlabelled values")
	func renderAssociatedValueEnumWithDefaultValues() throws {
		let enumDescriptor = AssociatedValueEnum(
			identifier: "NetworkResult"
		) {
			AssociatedValueEnumCase(
				"success",
				associatedValues: [
					AssociatedValueDescriptor(type: .data),
					AssociatedValueDescriptor(type: .string, defaultValue: .literal(.string(""))),
				],
			)
			AssociatedValueEnumCase(
				"failure",
				associatedValues: [
					AssociatedValueDescriptor(
						label: "afterAttempts",
						type: .int,
						defaultValue: .literal(.integer(1)),
					),
					AssociatedValueDescriptor(
						type: .optional(.identifier("Error")),
						defaultValue: .literal(.nil)
					)
				],
			)
		}
		let output = RenderTest.render { renderer in
			renderer.renderEnum(enumDescriptor)
		}
		let expected = """
		enum NetworkResult {
		    case success(Data, String = "")
		    case failure(afterAttempts: Int = 1, Optional<Error> = nil)
		}
		
		"""
		#expect(output == expected)
	}
}

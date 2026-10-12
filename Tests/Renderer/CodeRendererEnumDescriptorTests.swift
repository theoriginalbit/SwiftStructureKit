//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration, .renderer))
struct CodeRendererEnumDescriptorTests {

	@Test("Render uninhabited enum")
	func renderUninhabitedEnum() {
		let enumDescriptor = PlainEnumDescriptor("Direction")

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
		let enumDescriptor = PlainEnumDescriptor(
			"Result",
			accessModifier: .public,
			genericTypes: [.identifier("Success"), .identifier("Failure")],
			conformances: [.sendable],
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
		let enumDescriptor = PlainEnumDescriptor(
			"CompassDirection",
			comment: "A compass direction.",
		) {
			PlainEnumCaseDescriptor("north", comment: "Heading north.")
			PlainEnumCaseDescriptor("south")
			PlainEnumCaseDescriptor("east")
			PlainEnumCaseDescriptor("west")
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
		let enumDescriptor = RawValueEnumDescriptor<String>(
			"HTTPMethod",
			accessModifier: .public,
			conformances: [.string]
		) {
			RawValueEnumCaseDescriptor("get", rawValue: "GET")
			RawValueEnumCaseDescriptor("post", rawValue: .string("POST"))
			RawValueEnumCaseDescriptor("custom")
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
		let enumDescriptor = RawValueEnumDescriptor(
			"StatusCode",
			conformances: [.int]
		) {
			RawValueEnumCaseDescriptor("ok", rawValue: 200)
			RawValueEnumCaseDescriptor("notFound", rawValue: .integer(404))
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

	@Test("Render associated value enum with labeled and unlabelled values")
	func renderAssociatedValueEnum() {
		let enumDescriptor = AssociatedValueEnumDescriptor("NetworkState") {
			AssociatedValueEnumCaseDescriptor("idle")
			AssociatedValueEnumCaseDescriptor(
				"loading",
				associatedValues: [.init(label: "progress", type: .double)]
			)
			AssociatedValueEnumCaseDescriptor(
				"success",
				associatedValues: [.init(label: "data", type: .identifier("Data")), .init(type: .string)]
			)
			AssociatedValueEnumCaseDescriptor(
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
		let enumDescriptor = PlainEnumDescriptor(
			"State",
			accessModifier: .public,
			cases: {
				PlainEnumCaseDescriptor("active")
				PlainEnumCaseDescriptor("inactive")
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
	func renderAssociatedValueEnumWithDefaultValues() {
		let enumDescriptor = AssociatedValueEnumDescriptor("NetworkResult") {
			AssociatedValueEnumCaseDescriptor(
				"success",
				associatedValues: [
					EnumCaseAssociatedValueDescriptor(type: .data),
					EnumCaseAssociatedValueDescriptor(type: .string, defaultValue: .literal(.string(""))),
				],
			)
			AssociatedValueEnumCaseDescriptor(
				"failure",
				associatedValues: [
					EnumCaseAssociatedValueDescriptor(
						label: "afterAttempts",
						type: .int,
						defaultValue: .literal(.integer(1)),
					),
					EnumCaseAssociatedValueDescriptor(
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

	@Test("Render namespace enum")
	func renderNamespaceEnum() throws {
		let enumDescriptor = PlainEnumDescriptor("L10n") {} members: {
			TypeMemberDescriptor.mark("Screen-based localization")

			TypeMemberDescriptor.enum("Screen") {} members: {
				TypeMemberDescriptor.function(
					name: "okay",
					returns: .string,
					isStatic: true,
				) {
					StatementDescriptor.return(.literal(.string("Okay")))
				}
			}

			TypeMemberDescriptor.mark("Ran out of ideas", sectionBreak: true)

			TypeMemberDescriptor.struct("Foo") {
				TypeMemberDescriptor.function(
					name: "bar",
					returns: .string,
				) {
					InlineCommentDescriptor("The first thing\nyou'll ever write")
					StatementDescriptor.return(.literal(.string("Hello, world!")))
				}
			}

			TypeMemberDescriptor.enum("CodingKeys") {
				RawValueEnumCaseDescriptor("key")
				RawValueEnumCaseDescriptor("localizationValue", rawValue: "loc_value")
			}
		}
		let output = RenderTest.render { renderer in
			renderer.renderEnum(enumDescriptor)
		}
		let expected = """
		enum L10n {
		    // MARK: Screen-based localization
		
		    enum Screen {
		        static func okay() -> String {
		            return "Okay"
		        }
		    }
		
		    // MARK: - Ran out of ideas
		
		    struct Foo {
		        func bar() -> String {
		            // The first thing
		            // you'll ever write
		            return "Hello, world!"
		        }
		    }
		
		    enum CodingKeys: String {
		        case key
		        case localizationValue = "loc_value"
		    }
		}

		"""
		try ReferenceTest.assert(output, matches: expected)
		#expect(output == expected)
	}
}

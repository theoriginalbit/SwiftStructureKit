//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct ExtensionRendererTests {
	@Test("Render an empty extension")
	func renderEmptyExtension() {
		let descriptor = ExtensionDescriptor("Point")
		let output = RenderTest.render { writer in
			ExtensionRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			extension Point {}

			""")
	}

	@Test("Render conformances before the where clause, with no generic parameter clause")
	func renderConformancesAndRequirements() {
		let descriptor = ExtensionDescriptor(
			"Array",
			comment: "Describes every element.",
			attributes: [
				.available("iOS 17, *"),
			],
			conformances: [
				"CustomStringConvertible",
				.sendable,
			],
			genericRequirements: [
				TypeConstraintDescriptor("Element", conformsTo: "CustomStringConvertible"),
			],
		)
		let output = RenderTest.render { writer in
			ExtensionRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			/// Describes every element.
			@available(iOS 17, *)
			extension Array: CustomStringConvertible, Sendable where Element: CustomStringConvertible {}

			""")
	}

	@Test("Render an access modifier on an extension without conformances")
	func renderAccessModifier() {
		let descriptor = ExtensionDescriptor(
			"Array",
			accessModifier: .public,
			genericRequirements: [
				TypeConstraintDescriptor("Element", conformsTo: .equatable),
			]) {
				DeclarationDescriptor.function(name: "reset") {}
			}
		let output = RenderTest.render(indentUsing: .tabs) { writer in
			ExtensionRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			public extension Array where Element: Equatable {
				func reset() {}
			}

			""")
	}

	@Test("Render the extended type as a type reference", arguments: [
		(TypeReference.identifier("Foundation.Date"), "extension Foundation.Date {}\n"),
		(.generic("Dictionary", arguments: [.string, .int]), "extension Dictionary<String, Int> {}\n"),
		(.array(.int), "extension Array<Int> {}\n"),
		(.optional("Wrapped"), "extension Optional<Wrapped> {}\n"),
		(.identifier("protocol"), "extension `protocol` {}\n"),
	])
	func renderExtendedType(type: TypeReference, expected: String) {
		let descriptor = ExtensionDescriptor(type)
		let output = RenderTest.render { writer in
			ExtensionRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: expected)
	}

	@Test("Render members separated by blank lines, including static storage")
	func renderMembers() {
		let descriptor = ExtensionDescriptor("Point", conformances: ["CustomStringConvertible"]) {
			PropertyDescriptor.let("origin", isStatic: true, type: "Point", defaultValue: .raw("Point()"))

			PropertyDescriptor.computed("description", type: .string) {
				StatementDescriptor.return(.literal(.string("point")))
			}

			DeclarationDescriptor.function(name: "reset") {}
		}
		let output = RenderTest.render(indentUsing: .tabs) { writer in
			ExtensionRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			extension Point: CustomStringConvertible {
				static let origin: Point = Point()

				var description: String {
					return "point"
				}

				func reset() {}
			}

			""")
	}
}

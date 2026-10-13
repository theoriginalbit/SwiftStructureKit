//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct ProtocolRendererTests {
	@Test("Render empty protocol")
	func renderEmptyProtocol() {
		let descriptor = ProtocolDescriptor("Marker") {}
		let output = RenderTest.render { writer in
			ProtocolRenderer.render(descriptor, to: &writer)
		}

		#expect(output == """
			protocol Marker {
			}

			""")
	}

	@Test("Render protocol header and documentation comment")
	func renderProtocolHeader() {
		let descriptor = ProtocolDescriptor(
			"Sequence",
			comment: "A sequence of values.",
			accessModifier: .public,
			genericTypes: [.identifier("Element")],
			conformances: [.sendable],
		) {}
		let output = RenderTest.render { writer in
			ProtocolRenderer.render(descriptor, to: &writer)
		}

		#expect(output == """
			/// A sequence of values.
			public protocol Sequence<Element>: Sendable {
			}

			""")
	}

	@Test("Render protocol associated types, properties, and function requirements")
	func renderProtocolMembers() throws {
		let descriptor = ProtocolDescriptor("Readable") {
			ProtocolAssociatedtypeDescriptor(
				.identifier("Content"),
				conformsTo: .equatable,
				isPrimary: true,
			)
			ProtocolAssociatedtypeDescriptor(
				.identifier("Element"),
				sameTypeAs: .identifier("Content"),
			)
			ProtocolPropertyDescriptor(
				comment: "The current value.",
				identifier: "value",
				type: .identifier("Content"),
				accessorSpecifier: .get,
			)
			ProtocolPropertyDescriptor(
				comment: nil,
				identifier: "count",
				type: .int,
				accessorSpecifier: .getSet,
			)
			ProtocolPropertyDescriptor(
				comment: nil,
				identifier: "borrowedValue",
				type: .identifier("Content"),
				accessorSpecifier: .borrow,
			)
			ProtocolPropertyDescriptor(
				comment: nil,
				identifier: "mutableValue",
				type: .identifier("Content"),
				accessorSpecifier: .borrowMutate,
			)
			ProtocolMemberDescriptor.typealias(
				ProtocolTypealiasDescriptor(.identifier("Alias"), assignedType: .identifier("Content"))
			)
			FunctionSignatureDescriptor(
				comment: "Reads the next value.",
				kind: .function("read", returns: .identifier("Content")),
			)
		}
		let output = RenderTest.render(indentUsing: .tabs) { writer in
			ProtocolRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			protocol Readable<Content> {
				associatedtype Content: Equatable

				associatedtype Element = Content

				/// The current value.
				var value: Content { get }

				var count: Int { get set }

				var borrowedValue: Content { borrow }

				var mutableValue: Content { borrow mutate }

				typealias Alias = Content

				/// Reads the next value.
				func read() -> Content
			}

			"""
		try ReferenceTest.assert(output, matches: expected)
	}
}

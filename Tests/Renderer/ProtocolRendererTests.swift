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

		expectRendered(output, equals: """
			protocol Marker {}

			""")
	}

	@Test("Sanitize protocol and property identifiers")
	func sanitizeProtocolAndPropertyIdentifiers() {
		let descriptor = ProtocolDescriptor("$Readable") {
			ProtocolPropertyDescriptor(
				comment: nil,
				identifier: "class",
				type: .identifier("$Value"),
				accessorSpecifier: .get,
			)
		}
		let output = RenderTest.render { writer in
			ProtocolRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			protocol $Readable {
			    var `class`: $Value { get }
			}

			""")
	}

	@Test("Render protocol header and documentation comment")
	func renderProtocolHeader() {
		let descriptor = ProtocolDescriptor(
			"Sequence",
			comment: "A sequence of values.",
			accessModifier: .public,
			attributes: [.mainActor],
			genericParameters: ["Element"],
			conformances: [.sendable],
		) {}
		let output = RenderTest.render { writer in
			ProtocolRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			/// A sequence of values.
			@MainActor
			public protocol Sequence<Element>: Sendable {}

			""")
	}

	@Test("Render protocol associated types, properties, and function requirements")
	func renderProtocolMembers() throws {
		let descriptor = ProtocolDescriptor("Readable") {
			ProtocolAssociatedtypeDescriptor(
				"Content",
				conformsTo: .equatable,
				isPrimary: true,
			)
			ProtocolAssociatedtypeDescriptor(
				"Element",
				defaultType: .identifier("Content"),
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
				ProtocolTypealiasDescriptor("Alias", assignedType: .identifier("Content"))
			)
			FunctionSignatureDescriptor(
				comment: "Reads the next value.",
				kind: .function("read", returns: .identifier("Content")),
			)
			FunctionSignatureDescriptor(
				kind: .subscript(returns: .identifier("Content")),
				parameters: [.init("index", label: "at", type: .int)],
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
			
				subscript(at index: Int) -> Content { get }
			}

			"""
		ReferenceTest.assert(output, matches: expected)
	}

	@Test("Render result builders on protocol properties and function parameters")
	func renderResultBuildersOnProtocolMembers() {
		let descriptor = ProtocolDescriptor("Renderable") {
			ProtocolPropertyDescriptor(
				comment: nil,
				attributes: [.resultBuilder("ViewBuilder")],
				identifier: "body",
				type: .identifier("Content"),
				accessorSpecifier: .get,
			)
			FunctionSignatureDescriptor(
				kind: .function("render"),
				parameters: [
					.init("content", type: .identifier("Content"), attributes: [.resultBuilder("ViewBuilder")])
				],
			)
		}
		let output = RenderTest.render { writer in
			ProtocolRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			protocol Renderable {
			    @ViewBuilder
			    var body: Content { get }

			    func render(@ViewBuilder content: Content)
			}

			""")
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct TypealiasRendererTests {
	@Test("Render typealias")
	func renderTypealias() {
		let descriptor = TypealiasDescriptor(
			"StringAlias",
			assignedType: .string,
		)
		let output = RenderTest.render { writer in
			TypealiasRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			typealias StringAlias = String

			""")
	}

	@Test("Render access modifier and composed assigned types")
	func renderAccessModifierAndComposedTypes() {
		let descriptor = TypealiasDescriptor(
			"Value",
			accessModifier: .public,
			attributes: [.available("macOS 15, *")],
			assignedTypes: [.sendable, .equatable],
		)
		let output = RenderTest.render { writer in
			TypealiasRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			@available(macOS 15, *)
			public typealias Value = Sendable & Equatable

			""")
	}
}

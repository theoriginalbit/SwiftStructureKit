//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import OrderedCollections
import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct TypealiasRendererTests {
	@Test("Render typealias")
	func renderTypealias() {
		let descriptor = TypealiasDescriptor(
			.identifier("StringAlias"),
			assignedType: .string,
		)
		let output = RenderTest.render { writer in
			TypealiasRenderer.render(descriptor, to: &writer)
		}

		#expect(output == """
			typealias StringAlias = String

			""")
	}

	@Test("Render access modifier and composed assigned types")
	func renderAccessModifierAndComposedTypes() {
		let descriptor = TypealiasDescriptor(
			.identifier("Value"),
			accessModifier: .public,
			assignedTypes: [.sendable, .equatable],
		)
		let output = RenderTest.render { writer in
			TypealiasRenderer.render(descriptor, to: &writer)
		}

		#expect(output == """
			public typealias Value = Sendable & Equatable

			""")
	}
}

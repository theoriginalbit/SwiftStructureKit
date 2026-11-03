//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct ImportRendererTests {
	@Test func renderSimpleImport() {
		let descriptor = ImportDescriptor("Foundation")
		let output = RenderTest.render { writer in
			ImportRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			import Foundation

			""")
	}

	@Test func renderSubmoduleImport() {
		let descriptor = ImportDescriptor("Darwin", submodule: "C")
		let output = RenderTest.render { writer in
			ImportRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			import Darwin.C

			""")
	}

	@Test(arguments: zip(AccessModifierDescriptor.allCases, ["public", "package", "internal", "fileprivate", "private"]))
	func renderImportWithAccessModifier(accessModifier: AccessModifierDescriptor, rendered: String) {
		let descriptor = ImportDescriptor("Foundation", accessModifier: accessModifier)
		let output = RenderTest.render { writer in
			ImportRenderer.render(descriptor, to: &writer)
		}

		expectRendered(output, equals: """
			\(rendered) import Foundation

			""")
	}
}

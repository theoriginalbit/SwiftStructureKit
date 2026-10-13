//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct SwiftFileTests {
	@Test("Render a file header and top-level declarations")
	func renderFile() throws {
		let descriptor = SwiftFile(
			headerComment: "Generated source.",
			imports: [
				ImportDescriptor("Foundation"),
				ImportDescriptor(
					"SwiftStructureKit",
					submodule: "Descriptors",
					accessModifier: .public,
					attributes: ["_exported", "@preconcurrency"],
				),
				ImportDescriptor(
					"Foundation",
					submodule: "Date",
					kind: .structure,
				),
			],
		) {
			TypeMemberDescriptor.function(name: "greeting", returns: .string) {
				StatementDescriptor.return(.literal(.string("Hello")))
			}

			StructDescriptor("Person") {}

			TypeMemberDescriptor.enum("Status") {
				"active"
			}
		}

		try ReferenceTest.assert(
			descriptor.render(),
			matches: Fixtures.url("FileDescriptorTests_renderFile"),
		)
	}

	@Test("Render an empty file as empty data")
	func renderEmptyFile() {
		let descriptor = SwiftFile {}

		#expect(descriptor.render().isEmpty)
	}
}

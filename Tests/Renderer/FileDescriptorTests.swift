//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct FileDescriptorTests {
	@Test("Render a file header and top-level declarations")
	func renderFile() throws {
		let descriptor = FileDescriptor(headerComment: "Generated source.") {
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
		let descriptor = FileDescriptor {}

		#expect(descriptor.render().isEmpty)
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit
import SwiftStructureKitTestSupport

private typealias Decl = TopLevelDeclarationDescriptor

@Suite struct TopLevelDeclarationDescriptorTests {
	@Test("Render a file with some conditional top-level declarations") func compilerConditionals() throws {
		let descriptor = SwiftFile(
			headerComment: "Generated source.",
			imports: [
				.foundation,
			],
		) {
			Decl.if("DEBUG") {
				StructDescriptor("Person") {}
			}

			Decl.if("TESTING") {
				StructDescriptor("Status") {
					DeclarationDescriptor.function(name: "greeting", returns: .string) {
						StatementDescriptor.return(.literal(.string("Hello")))
					}
				}
			} else: {
				StructDescriptor("Status") {
					DeclarationDescriptor.function(name: "greeting", returns: .string) {
						StatementDescriptor.return(.literal(.string("World")))
					}
				}
			}

			Decl.if("canImport(UIKit)") {
				TypealiasDescriptor("View", assignedType: .identifier("UIView"))
			}.elseIf("canImport(AppKit)") {
				TypealiasDescriptor("View", assignedType: .identifier("NSView"))
			}.else {
				DiagnosticDirectiveDescriptor.warning("unsupported platform")
			}
		}

		expectRendered(
			descriptor.render(),
			equals: try Fixtures.url("TopLevelDeclarationDescriptorTests_compilerConditionals"),
		)
	}
}

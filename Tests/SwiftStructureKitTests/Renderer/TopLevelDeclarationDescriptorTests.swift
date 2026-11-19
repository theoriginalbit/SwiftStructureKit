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
			// an import at the very top will not get rendered with the other imports as a new
			// section of the document has been started. Presumably no one would actually do
			// this, they'd use the SwiftFile property for top-of-file imports and then this
			// declaration for imports in #if blocks
			.import("Crypto")

			Decl.if("DEBUG") {
				StructDescriptor("Person") {}
			}

			Decl.if("TESTING") {
				StructDescriptor("Status") {
					DeclarationDescriptor.function(name: "greeting", returns: .string) {
						StatementDescriptor.return(.literal(.string("Hello")))
					}
				}

				ExtensionDescriptor("String") {}
			} else: {
				StructDescriptor("Status") {
					DeclarationDescriptor.function(name: "greeting", returns: .string) {
						StatementDescriptor.return(.literal(.string("World")))
					}
				}
			}

			Decl.comment("What even are we doing anymore?")

			Decl.if("canImport(UIKit)") {
				.import(.uiKit)
				TypealiasDescriptor("View", assignedType: .identifier("UIView"))
			}.elseIf("canImport(AppKit)") {
				ImportDescriptor("AppKit")
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

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct DiagnosticDirectiveRendererTests {
	@Test("Render warning diagnostic directive")
	func renderWarningDiagnosticDirective() throws {
		let descriptor = DiagnosticDirectiveDescriptor.warning("This is my warning")
		let output = RenderTest.render { writer in
			DiagnosticDirectiveRenderer.render(descriptor, to: &writer)
		}
		let expected = """
		#warning("This is my warning")
		
		"""
		expectRendered(output, equals: expected)
	}

	@Test("Render error diagnostic directive")
	func renderErrorDiagnosticDirective() throws {
		let descriptor = DiagnosticDirectiveDescriptor.error("This is an error")
		let output = RenderTest.render { writer in
			DiagnosticDirectiveRenderer.render(descriptor, to: &writer)
		}
		let expected = """
		#error("This is an error")
		
		"""
		expectRendered(output, equals: expected)
	}
}

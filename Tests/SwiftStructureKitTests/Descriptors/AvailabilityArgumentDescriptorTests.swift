//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit
import SwiftStructureKitTestSupport

@Suite struct AvailabilityArgumentDescriptorTests {
	@Test("Render and compile platform availability")
	func renderPlatform() throws {
		let ios = AttributeDescriptor.available(AvailabilityArgumentsList(iOS: 13.1))
		let renderedIos = TokenWriter.render { writer in
			AttributeRenderer.render(ios, to: &writer)
		}
		expectRendered(renderedIos, equals: "@available(iOS 13.1, *)")
		try assertCompilation("""
			\(renderedIos)
			func unavailableOnIos() {}
			""")

		let iosAndMacOS = AttributeDescriptor.available(AvailabilityArgumentsList(iOS: 16.0, macOS: 26.0))
		let renderedIosAndMacOS = TokenWriter.render { writer in
			AttributeRenderer.render(iosAndMacOS, to: &writer)
		}
		expectRendered(renderedIosAndMacOS, equals: "@available(iOS 16.0, macOS 26.0, *)")
		try assertCompilation("""
			\(renderedIosAndMacOS)
			func unavailableOnIosAndMacOS() {}
			""")
	}

	@Test("Render and compile noasync availability")
	func renderAndCompileNoasyncAvailability() throws {
		let noasyncAttribute = AttributeDescriptor.available(.wildcard, .noasync)
		let renderedNoasync = TokenWriter.render { writer in
			AttributeRenderer.render(noasyncAttribute, to: &writer)
		}

		expectRendered(renderedNoasync, equals: "@available(*, noasync)")
		try assertCompilation("""
			\(renderedNoasync)
			func unavailableFromAsyncContext() {}
			""")
	}
}

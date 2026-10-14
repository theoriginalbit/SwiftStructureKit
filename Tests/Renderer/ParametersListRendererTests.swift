//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct ParametersListRendererTests {
	@Test("Render empty parameters list")
	func renderEmptyParametersList() {
		let list = ParametersList()
		let output = RenderTest.render { writer in
			ParametersListRenderer.render(list, to: &writer)
		}
		#expect(output == "()\n")
	}

	@Test("Render single parameter with implicit label")
	func renderSingleParameterWithoutLabel() {
		let list: ParametersList = [.init("name", type: .string)]
		let output = RenderTest.render { writer in
			ParametersListRenderer.render(list, to: &writer)
		}
		#expect(output == "(name: String)\n")
	}

	@Test("Render single parameter with explicit custom label")
	func renderSingleParameterWithCustomLabel() {
		let list: ParametersList = [.init("key", label: "for", type: .string)]
		let output = RenderTest.render { writer in
			ParametersListRenderer.render(list, to: &writer)
		}
		#expect(output == "(`for` key: String)\n")
	}

	@Test("Render single parameter with wildcard label")
	func renderSingleParameterWithWildcardLabel() {
		let list: ParametersList = [.init("raw", label: "_", type: .int)]
		let output = RenderTest.render { writer in
			ParametersListRenderer.render(list, to: &writer)
		}
		#expect(output == "(_ raw: Int)\n")
	}

	@Test("Render single parameter with default value")
	func renderSingleParameterWithDefaultValue() {
		let list: ParametersList = [.init("count", type: .int, defaultValue: .literal(.integer(10)))]
		let output = RenderTest.render { writer in
			ParametersListRenderer.render(list, to: &writer)
		}
		#expect(output == "(count: Int = 10)\n")
	}

	@Test("Render inout parameters", arguments: [
		(false, "(value: Int)\n"),
		(true, "(value: inout Int)\n"),
	])
	func renderInoutParameter(isInout: Bool, expected: String) {
		let list: ParametersList = [.init("value", type: .int, isInout: isInout)]
		let output = RenderTest.render { writer in
			ParametersListRenderer.render(list, to: &writer)
		}

		#expect(output == expected)
	}

	@Test("Render multiple parameters with mixed labels, default values, and types")
	func renderMultipleParametersWithMixedOptions() {
		let list: ParametersList = [
			.init("key", label: "for", type: .string),
			.init("count", type: .int, defaultValue: .literal(.integer(10))),
			.init("verbose", label: "_", type: .bool, defaultValue: .literal(.boolean(false)))
		]
		let output = RenderTest.render { writer in
			ParametersListRenderer.render(list, to: &writer)
		}
		#expect(output == "(`for` key: String, count: Int = 10, _ verbose: Bool = false)\n")
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration, .renderer)) struct ParametersListRenderTests {
	@Test("Render empty parameters list")
	func renderEmptyParametersList() {
		let list = ParametersList()
		let output = RenderTest.render { renderer in
			renderer.renderParametersList(list)
		}
		#expect(output == "()\n")
	}

	@Test("Render single parameter with implicit label")
	func renderSingleParameterWithoutLabel() {
		let list: ParametersList = [.init("name", type: "String")]
		let output = RenderTest.render { renderer in
			renderer.renderParametersList(list)
		}
		#expect(output == "(name: String)\n")
	}

	@Test("Render single parameter with explicit custom label")
	func renderSingleParameterWithCustomLabel() {
		let list: ParametersList = [.init(label: "for", "key", type: "String")]
		let output = RenderTest.render { renderer in
			renderer.renderParametersList(list)
		}
		#expect(output == "(for key: String)\n")
	}

	@Test("Render single parameter with wildcard label")
	func renderSingleParameterWithWildcardLabel() {
		let list: ParametersList = [.init(label: "_", "raw", type: "Int")]
		let output = RenderTest.render { renderer in
			renderer.renderParametersList(list)
		}
		#expect(output == "(_ raw: Int)\n")
	}

	@Test("Render single parameter with default value")
	func renderSingleParameterWithDefaultValue() {
		let list: ParametersList = [.init("count", type: "Int", defaultValue: .literal(.integer(10)))]
		let output = RenderTest.render { renderer in
			renderer.renderParametersList(list)
		}
		#expect(output == "(count: Int = 10)\n")
	}

	@Test("Render single parameter with closure type")
	func renderSingleParameterWithClosureType() {
		let list: ParametersList = [.init("completion", type: "() -> Void")]
		let output = RenderTest.render { renderer in
			renderer.renderParametersList(list)
		}
		#expect(output == "(completion: () -> Void)\n")
	}

	@Test("Render multiple parameters with mixed labels, default values, and types")
	func renderMultipleParametersWithMixedOptions() {
		let list: ParametersList = [
			.init(label: "for", "key", type: "String"),
			.init("count", type: "Int", defaultValue: .literal(.integer(10))),
			.init(label: "_", "verbose", type: "Bool", defaultValue: .literal(.boolean(false)))
		]
		let output = RenderTest.render { renderer in
			renderer.renderParametersList(list)
		}
		#expect(output == "(for key: String, count: Int = 10, _ verbose: Bool = false)\n")
	}
}

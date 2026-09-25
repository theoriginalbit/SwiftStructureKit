//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration, .renderer)) struct ParametersListRenderTests {
	@Test("Render empty parameters list")
	func renderEmptyParametersList() {
		let renderer = CodeRenderer()
		let list = ParametersList()
		renderer.renderParametersList(list)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "()\n")
	}

	@Test("Render single parameter with implicit label")
	func renderSingleParameterWithoutLabel() {
		let renderer = CodeRenderer()
		let list: ParametersList = [.init("name", type: "String")]
		renderer.renderParametersList(list)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "(name: String)\n")
	}

	@Test("Render single parameter with explicit custom label")
	func renderSingleParameterWithCustomLabel() {
		let renderer = CodeRenderer()
		let list: ParametersList = [.init(label: "for", "key", type: "String")]
		renderer.renderParametersList(list)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "(for key: String)\n")
	}

	@Test("Render single parameter with wildcard label")
	func renderSingleParameterWithWildcardLabel() {
		let renderer = CodeRenderer()
		let list: ParametersList = [.init(label: "_", "raw", type: "Int")]
		renderer.renderParametersList(list)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "(_ raw: Int)\n")
	}

	@Test("Render single parameter with default value")
	func renderSingleParameterWithDefaultValue() {
		let renderer = CodeRenderer()
		let list: ParametersList = [.init("count", type: "Int", defaultValue: .literal(.integer(10)))]
		renderer.renderParametersList(list)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "(count: Int = 10)\n")
	}

	@Test("Render single parameter with closure type")
	func renderSingleParameterWithClosureType() {
		let renderer = CodeRenderer()
		let list: ParametersList = [.init("completion", type: "() -> Void")]
		renderer.renderParametersList(list)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "(completion: () -> Void)\n")
	}

	@Test("Render multiple parameters with mixed labels, default values, and types")
	func renderMultipleParametersWithMixedOptions() {
		let renderer = CodeRenderer()
		let list: ParametersList = [
			.init(label: "for", "key", type: "String"),
			.init("count", type: "Int", defaultValue: .literal(.integer(10))),
			.init(label: "_", "verbose", type: "Bool", defaultValue: .literal(.boolean(false)))
		]
		renderer.renderParametersList(list)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "(for key: String, count: Int = 10, _ verbose: Bool = false)\n")
	}
}

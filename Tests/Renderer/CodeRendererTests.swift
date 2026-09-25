//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct CodeRendererTests {
	@Test("Render basic function without body")
	func renderBasicFunctionSignature() {
		let renderer = CodeRenderer()
		let signature = FunctionSignatureDescriptor(
			kind: .function("doSomething"),
			parameters: []
		)
		renderer.renderFunctionSignature(signature)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "func doSomething()\n")
	}

	@Test("Render static public function with parameters and return type")
	func renderComplexFunctionSignature() {
		let renderer = CodeRenderer()
		let signature = FunctionSignatureDescriptor(
			accessModifier: .public,
			kind: .function("calculate", returns: "Int", isStatic: true),
			parameters: [
				.init(label: "for", "key", type: "String"),
				.init("count", type: "Int", defaultValue: .literal(.integer(10)))
			]
		)
		renderer.renderFunctionSignature(signature)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "public static func calculate(for key: String, count: Int = 10) -> Int\n")
	}

	@Test("Render function with async and throwing effect specifiers")
	func renderFunctionWithEffects() {
		let renderer = CodeRenderer()
		let signature = FunctionSignatureDescriptor(
			kind: .function("fetchData"),
			parameters: [],
			effects: EffectSpecifiers(isAsync: true, throwingSpecifier: .throws)
		)
		renderer.renderFunctionSignature(signature)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "func fetchData() async throws\n")
	}

	@Test("Render function with rethrows effect specifier")
	func renderFunctionWithRethrows() {
		let renderer = CodeRenderer()
		let signature = FunctionSignatureDescriptor(
			kind: .function("performAction"),
			parameters: [],
			effects: EffectSpecifiers(isAsync: false, throwingSpecifier: .rethrows)
		)
		renderer.renderFunctionSignature(signature)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "func performAction() rethrows\n")
	}

	@Test("Render function with typed throws effect specifier")
	func renderFunctionWithTypedThrows() {
		let renderer = CodeRenderer()
		let signature = FunctionSignatureDescriptor(
			kind: .function("validate"),
			parameters: [],
			effects: EffectSpecifiers(isAsync: true, throwingSpecifier: .typed("ValidationError"))
		)
		renderer.renderFunctionSignature(signature)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "func validate() async throws(ValidationError)\n")
	}

	@Test("Render initializers: standard and failable")
	func renderInitializers() {
		let renderer1 = CodeRenderer()
		let initSignature = FunctionSignatureDescriptor(
			accessModifier: .public,
			kind: .initializer(failable: false),
			parameters: [.init("name", type: "String")]
		)
		renderer1.renderFunctionSignature(initSignature)
		#expect(String(decoding: renderer1.finish(), as: UTF8.self) == "public init(name: String)\n")

		let renderer2 = CodeRenderer()
		let failableInitSignature = FunctionSignatureDescriptor(
			accessModifier: .fileprivate,
			kind: .initializer(failable: true),
			parameters: [.init(label: "_", "raw", type: "Int")]
		)
		renderer2.renderFunctionSignature(failableInitSignature)
		#expect(String(decoding: renderer2.finish(), as: UTF8.self) == "fileprivate init?(_ raw: Int)\n")
	}

	@Test("Render FunctionDescriptor with body and statements")
	func renderFunctionWithBody() {
		let renderer = CodeRenderer()
		let function = FunctionDescriptor(
			signature: FunctionSignatureDescriptor(
				accessModifier: .internal,
				kind: .function("greet", returns: "String"),
				parameters: [.init("name", type: "String")]
			)
		) {
			StatementDescriptor.return(.literal(.string("Hello!")))
		}
		renderer.renderFunction(function)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		let expected = """
		internal func greet(name: String) -> String {
		    return "Hello!"
		}

		"""
		#expect(output == expected)
	}

	@Test("Render DocComment with single parameter documentation")
	func renderDocCommentSingleParameter() {
		let renderer = CodeRenderer()
		let signature = FunctionSignatureDescriptor(
			comment: "Performs process.",
			kind: .function("process"),
			parameters: [
				.init("input", type: "Data", comment: "The input data to process.")
			]
		)
		renderer.renderFunctionSignature(signature)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		let expected = """
		/// Performs process.
		///
		/// - Parameter input: The input data to process.
		func process(input: Data)

		"""
		#expect(output == expected)
	}

	@Test("Render DocComment with multiple parameter documentations")
	func renderDocCommentMultipleParameters() {
		let renderer = CodeRenderer()
		let signature = FunctionSignatureDescriptor(
			comment: DocCommentDescriptor("Configures the item.\nAdditional details line."),
			kind: .function("configure"),
			parameters: [
				.init(label: "with", "name", type: "String", comment: "The item name."),
				.init("count", type: "Int", comment: "The total count.")
			]
		)
		renderer.renderFunctionSignature(signature)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		let expected = """
		/// Configures the item.
		/// Additional details line.
		///
		/// - Parameters:
		///   - name: The item name.
		///   - count: The total count.
		func configure(with name: String, count: Int)

		"""
		#expect(output == expected)
	}

	@Test("Render parameter comments ignored if function doc comment is nil")
	func renderParameterCommentsIgnoredWithoutDocComment() {
		let renderer = CodeRenderer()
		let signature = FunctionSignatureDescriptor(
			comment: nil,
			kind: .function("run"),
			parameters: [
				.init("step", type: "Int", comment: "Step count")
			]
		)
		renderer.renderFunctionSignature(signature)
		let output = String(decoding: renderer.finish(), as: UTF8.self)
		#expect(output == "func run(step: Int)\n")
	}
}

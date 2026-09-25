//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct CodeRendererTests {
	@Test("Render basic function without body")
	func renderBasicFunctionSignature() {
		let signature = FunctionSignatureDescriptor(
			kind: .function("doSomething"),
			parameters: []
		)
		let output = RenderTest.render { renderer in
			renderer.renderFunctionSignature(signature)
		}
		#expect(output == "func doSomething()\n")
	}

	@Test("Render static public function with parameters and return type")
	func renderComplexFunctionSignature() {
		let signature = FunctionSignatureDescriptor(
			accessModifier: .public,
			kind: .function("calculate", returns: "Int", isStatic: true),
			parameters: [
				.init(label: "for", "key", type: "String"),
				.init("count", type: "Int", defaultValue: .literal(.integer(10)))
			]
		)
		let output = RenderTest.render { renderer in
			renderer.renderFunctionSignature(signature)
		}
		#expect(output == "public static func calculate(for key: String, count: Int = 10) -> Int\n")
	}

	@Test("Render function with async and throwing effect specifiers")
	func renderFunctionWithEffects() {
		let signature = FunctionSignatureDescriptor(
			kind: .function("fetchData"),
			parameters: [],
			effects: EffectSpecifiers(isAsync: true, throwingSpecifier: .throws)
		)
		let output = RenderTest.render { renderer in
			renderer.renderFunctionSignature(signature)
		}
		#expect(output == "func fetchData() async throws\n")
	}

	@Test("Render function with rethrows effect specifier")
	func renderFunctionWithRethrows() {
		let signature = FunctionSignatureDescriptor(
			kind: .function("performAction"),
			parameters: [],
			effects: EffectSpecifiers(isAsync: false, throwingSpecifier: .rethrows)
		)
		let output = RenderTest.render { renderer in
			renderer.renderFunctionSignature(signature)
		}
		#expect(output == "func performAction() rethrows\n")
	}

	@Test("Render function with typed throws effect specifier")
	func renderFunctionWithTypedThrows() {
		let signature = FunctionSignatureDescriptor(
			kind: .function("validate"),
			parameters: [],
			effects: EffectSpecifiers(isAsync: true, throwingSpecifier: .typed("ValidationError"))
		)
		let output = RenderTest.render { renderer in
			renderer.renderFunctionSignature(signature)
		}
		#expect(output == "func validate() async throws(ValidationError)\n")
	}

	@Test("Render initializers: standard and failable")
	func renderInitializers() {
		let initSignature = FunctionSignatureDescriptor(
			accessModifier: .public,
			kind: .initializer(failable: false),
			parameters: [.init("name", type: "String")]
		)
		let initOutput = RenderTest.render { renderer in
			renderer.renderFunctionSignature(initSignature)
		}
		#expect(initOutput == "public init(name: String)\n")

		let failableInitSignature = FunctionSignatureDescriptor(
			accessModifier: .fileprivate,
			kind: .initializer(failable: true),
			parameters: [.init(label: "_", "raw", type: "Int")]
		)
		let failableInitOutput = RenderTest.render { renderer in
			renderer.renderFunctionSignature(failableInitSignature)
		}
		#expect(failableInitOutput == "fileprivate init?(_ raw: Int)\n")
	}

	@Test("Render FunctionDescriptor with body and statements")
	func renderFunctionWithBody() {
		let function = FunctionDescriptor(
			signature: FunctionSignatureDescriptor(
				accessModifier: .internal,
				kind: .function("greet", returns: "String"),
				parameters: [.init("name", type: "String")]
			)
		) {
			StatementDescriptor.return(.literal(.string("Hello!")))
		}
		let output = RenderTest.render { renderer in
			renderer.renderFunction(function)
		}
		let expected = """
		internal func greet(name: String) -> String {
		    return "Hello!"
		}

		"""
		#expect(output == expected)
	}

	@Test("Render DocComment with single parameter documentation")
	func renderDocCommentSingleParameter() {
		let signature = FunctionSignatureDescriptor(
			comment: "Performs process.",
			kind: .function("process"),
			parameters: [
				.init("input", type: "Data", comment: "The input data to process.")
			]
		)
		let output = RenderTest.render { renderer in
			renderer.renderFunctionSignature(signature)
		}
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
		let signature = FunctionSignatureDescriptor(
			comment: DocCommentDescriptor("Configures the item.\nAdditional details line."),
			kind: .function("configure"),
			parameters: [
				.init(label: "with", "name", type: "String", comment: "The item name."),
				.init("count", type: "Int", comment: "The total count.")
			]
		)
		let output = RenderTest.render { renderer in
			renderer.renderFunctionSignature(signature)
		}
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
		let signature = FunctionSignatureDescriptor(
			comment: nil,
			kind: .function("run"),
			parameters: [
				.init("step", type: "Int", comment: "Step count")
			]
		)
		let output = RenderTest.render { renderer in
			renderer.renderFunctionSignature(signature)
		}
		#expect(output == "func run(step: Int)\n")
	}
}

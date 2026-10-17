//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct FunctionRendererTests {
	@Test("Render basic function without body")
	func renderBasicFunctionSignature() {
		let signature = FunctionSignatureDescriptor(
			kind: .function("doSomething"),
			parameters: []
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
		}
		#expect(output == "func doSomething()\n")
	}

	@Test("Render generic parameters and where requirements")
	func renderGenericSignatures() {
		let unconstrained = FunctionSignatureDescriptor(
			kind: .function("a1", returns: .identifier("T")),
			genericParameters: ["T"]
		)
		let constrained = FunctionSignatureDescriptor(
			kind: .function("a2", returns: .identifier("T")),
			genericParameters: [
				GenericParameterDescriptor("T", constraint: TypeComposition(.equatable))
			]
		)
		let qualifiedGenericArgument = FunctionSignatureDescriptor(
			kind: .function("c2"),
			parameters: [
				.init(
					"j",
					type: .generic("F", arguments: [.identifier("Int.Stride"), .identifier("T")])
				)
			],
			genericParameters: ["T"],
			genericRequirements: [
				TypeConstraintDescriptor("T", conformsTo: .equatable)
			]
		)

		let rendered = [unconstrained, constrained, qualifiedGenericArgument]
			.map { signature in
				RenderTest.render { writer in
					FunctionRenderer.renderSignature(signature, to: &writer)
				}
			}
			.joined()

		#expect(rendered == """
			func a1<T>() -> T
			func a2<T: Equatable>() -> T
			func c2<T>(j: F<Int.Stride, T>) where T: Equatable

			""")
	}

	@Test("Sanitize function and parameter identifiers")
	func sanitizeFunctionAndParameterIdentifiers() {
		let signature = FunctionSignatureDescriptor(
			comment: "Uses a sanitized parameter.",
			kind: .function("default", returns: .identifier("9-Result")),
			parameters: [
				.init("1value", label: "try", type: .identifier("$Payload"), comment: "The payload."),
				.init("raw-value", label: "_", type: .string),
			]
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
		}
		let expected = """
			/// Uses a sanitized parameter.
			///
			/// - Parameters:
			///   - _1value: The payload.
			///   - raw_hyphen_value: 
			func `default`(`try` _1value: $Payload, _ raw_hyphen_value: String) -> _9_hyphen_Result

			"""
		#expect(output == expected)
	}

	@Test("Render static public function with parameters and return type")
	func renderComplexFunctionSignature() {
		let signature = FunctionSignatureDescriptor(
			accessModifier: .public,
			kind: .function("calculate", returns: .int, isStatic: true),
			parameters: [
				.init("key", label: "for", type: .string),
				.init("count", type: .int, defaultValue: .literal(.integer(10)))
			]
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
		}
		#expect(output == "public static func calculate(`for` key: String, count: Int = 10) -> Int\n")
	}

	@Test("Render result builders on functions and parameters")
	func renderResultBuildersOnFunctionAndParameters() {
		let signature = FunctionSignatureDescriptor(
			accessModifier: .public,
			attributes: [.resultBuilder("ViewBuilder"), .inlinable, .discardableResult, .disfavoredOverload, .available("iOS 17, *")],
			kind: .function("render"),
			parameters: [
				.init(
					"content",
					type: .closure(parameters: [], returns: .string),
					attributes: [.resultBuilder("@ViewBuilder")],
				)
			]
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
		}

		#expect(output == "@ViewBuilder @inlinable @discardableResult @_disfavoredOverload @available(iOS 17, *) public func render(@ViewBuilder content: () -> String)\n")
	}

	@Test("Render closure effects and inout parameters in function signatures")
	func renderClosureEffectsAndInoutParameters() {
		let signature = FunctionSignatureDescriptor(
			kind: .function("perform"),
			parameters: [
				.init("value", type: .identifier("SomeObj"), isInout: true),
				.init(
					"completion",
					type: .closure(
						parameters: [.int],
						returns: .identifier("Void"),
						isEscaping: true,
						attributes: [.mainActor, .init("Sendable")],
						effects: EffectSpecifiers<ThrowingSpecifier>(isAsync: true, throwingSpecifier: .throws)
					),
				),
			]
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
		}
		let expected = """
		func perform(value: inout SomeObj, completion: @MainActor @Sendable @escaping (Int) async throws -> Void)

		"""
		#expect(output == expected)
	}

	@Test("Render function with async and throwing effect specifiers")
	func renderFunctionWithEffects() {
		let signature = FunctionSignatureDescriptor(
			kind: .function("fetchData"),
			parameters: [],
			effects: EffectSpecifiers<FunctionThrowingSpecifier>(isAsync: true, throwingSpecifier: .throws)
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
		}
		let expected = """
		func fetchData() async throws
		
		"""
		#expect(output == expected)
	}

	@Test("Render function with rethrows effect specifier")
	func renderFunctionWithRethrows() {
		let signature = FunctionSignatureDescriptor(
			kind: .function("performAction"),
			parameters: [],
			effects: EffectSpecifiers<FunctionThrowingSpecifier>(isAsync: false, throwingSpecifier: .rethrows)
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
		}
		#expect(output == "func performAction() rethrows\n")
	}

	@Test("Render function with typed throws effect specifier")
	func renderFunctionWithTypedThrows() {
		let signature = FunctionSignatureDescriptor(
			kind: .function("validate"),
			parameters: [],
			effects: EffectSpecifiers<FunctionThrowingSpecifier>(isAsync: true, throwingSpecifier: .typed(.identifier("ValidationError")))
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
		}
		#expect(output == "func validate() async throws(ValidationError)\n")
	}

	@Test("Render initializers: standard and failable")
	func renderInitializers() {
		let initSignature = FunctionSignatureDescriptor(
			accessModifier: .public,
			kind: .initializer(failable: false),
			parameters: [.init("name", type: .string)]
		)
		let initOutput = RenderTest.render { writer in
			FunctionRenderer.renderSignature(initSignature, to: &writer)
		}
		#expect(initOutput == "public init(name: String)\n")

		let failableInitSignature = FunctionSignatureDescriptor(
			accessModifier: .fileprivate,
			kind: .initializer(failable: true),
			parameters: [.init("raw", label: "_", type: .int)]
		)
		let failableInitOutput = RenderTest.render { writer in
			FunctionRenderer.renderSignature(failableInitSignature, to: &writer)
		}
		#expect(failableInitOutput == "fileprivate init?(_ raw: Int)\n")
	}

	@Test("Render instance and static subscripts")
	func renderSubscripts() {
		let instanceSubscript = FunctionSignatureDescriptor(
			kind: .subscript(returns: .string),
			parameters: [.init("index", label: "for", type: .int)]
		)
		let staticSubscript = FunctionSignatureDescriptor(
			kind: .subscript(returns: .identifier("Element"), isStatic: true),
			parameters: [.init("index", type: .int)]
		)

		let rendered = [instanceSubscript, staticSubscript]
			.map { signature in
				RenderTest.render { writer in
					FunctionRenderer.renderSignature(signature, to: &writer)
				}
			}
			.joined()

		#expect(rendered == """
			subscript(`for` index: Int) -> String { get }
			static subscript(index: Int) -> Element { get }

			""")
	}

	@Test("Render FunctionDescriptor with body and statements")
	func renderFunctionWithBody() {
		let function = FunctionDescriptor(
			signature: FunctionSignatureDescriptor(
				accessModifier: .internal,
				kind: .function("greet", returns: .string),
				parameters: [.init("name", type: .string)]
			)
		) {
			StatementDescriptor.return(.literal(.string("Hello!")))
		}
		let output = RenderTest.render { writer in
			FunctionRenderer.render(function, to: &writer)
		}
		let expected = """
		internal func greet(name: String) -> String {
		    return "Hello!"
		}

		"""
		#expect(output == expected)
	}

	@Test("Render subscript function")
	func renderSubscriptFunction() {
		let function = FunctionDescriptor(
			signature: FunctionSignatureDescriptor(
				kind: .subscript(returns: .string),
				parameters: [.init("index", label: "for", type: .int)]
			)) {
				StatementDescriptor.return(.raw("internal[index]"))
			}
		let output = RenderTest.render { writer in
			FunctionRenderer.render(function, to: &writer)
		}
		let expected = """
			subscript(`for` index: Int) -> String {
			    return internal[index]
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
				.init("input", type: .data, comment: "The input data to process.")
			]
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
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
				.init("name", label: "with", type: .string, comment: "The item name."),
				.init("count", type: .int, comment: "The total count.")
			]
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
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
				.init("step", type: .int, comment: "Step count")
			]
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.renderSignature(signature, to: &writer)
		}
		#expect(output == "func run(step: Int)\n")
	}
}

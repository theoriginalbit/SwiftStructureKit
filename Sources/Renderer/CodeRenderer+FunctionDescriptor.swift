//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderFunction(_ function: FunctionDescriptor) {
		renderFunction(function, to: &writer)
	}

	func renderFunction(_ function: FunctionDescriptor, to writer: inout CodeFileWriter) {
		renderFunctionSignature(function.signature, hasBody: function.body != nil, to: &writer)
		if let body = function.body {
			renderCodeBlock(body, to: &writer)
			writer.writeLine("}")
		}
	}

	func renderFunctionSignature(_ signature: FunctionSignatureDescriptor, hasBody: Bool = false) {
		renderFunctionSignature(signature, hasBody: hasBody, to: &writer)
	}

	func renderFunctionSignature(_ signature: FunctionSignatureDescriptor, hasBody: Bool = false, to writer: inout CodeFileWriter) {
		renderDocComment(for: signature, to: &writer)

		writer.writeLine { line in
			if let accessModifier = signature.accessModifier {
				line.token(renderedAccessModifier(accessModifier))
			}

			switch signature.kind {
			case let .initializer(failable):
				if failable {
					line.token("init?")
				} else {
					line.token("init")
				}
			case let .function(name, _, isStatic):
				if isStatic {
					line.token("static")
				}
				line.token("func")
				line.token(name)
			}

			renderParametersList(signature.parameters, into: &line)

			if let effects = signature.effects {
				line.space() // TODO: implementation detail knowing that parameter list renders a token at the end. need to be smarter somehow

				if effects.isAsync {
					line.token("async")
				}

				if let throwing = effects.throwingSpecifier {
					line.token(renderedThrowingSpecifier(throwing))
				}
			}

			if case let .function(_, returns, _) = signature.kind, let returns {
				line.space()
				line.token("->")
				line.token(renderedType(returns))
			}

			if hasBody {
				line.space()
				line.punctuation("{")
			}
		}
	}
}

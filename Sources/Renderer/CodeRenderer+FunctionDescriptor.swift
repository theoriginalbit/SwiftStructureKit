//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderFunction(_ function: FunctionDescriptor) {
		renderFunction(function, to: &writer)
	}

	func renderFunction(_ function: FunctionDescriptor, to writer: inout CodeFileWriter) {
		renderDocComment(for: function.signature, to: &writer)

		writer.writeLine { line in
			_renderFunctionSignature(function.signature, to: &line)
			line.space()
			line.punctuation("{")
		}
		renderCodeBlock(function.body, to: &writer)

		writer.writeLine("}")
	}

	func renderFunctionSignature(_ signature: FunctionSignatureDescriptor) {
		renderFunctionSignature(signature, to: &writer)
	}

	func renderFunctionSignature(_ signature: FunctionSignatureDescriptor, to writer: inout CodeFileWriter) {
		renderDocComment(for: signature, to: &writer)

		writer.writeLine { line in
			_renderFunctionSignature(signature, to: &line)
		}
	}

	private func _renderFunctionSignature(_ signature: FunctionSignatureDescriptor, to line: inout LineWriter) {
		if let accessModifier = signature.accessModifier {
			line.token(renderedAccessModifier(accessModifier))
		}

		switch signature.kind {
		case let .initializer(failable):
			line.token("init")
			if failable {
				line.punctuation("?")
			}
		case let .function(name, _, isStatic):
			if isStatic {
				line.token("static")
			}
			line.token("func")
			line.token(name)
		}

		renderParametersList(signature.parameters, into: &line)

		if !signature.effects.hasEffects {
			line.space() // TODO: implementation detail knowing that parameter list renders a token at the end. need to be smarter somehow

			if signature.effects.isAsync {
				line.token("async")
			}

			if let throwing = signature.effects.throwingSpecifier {
				line.token(renderedThrowingSpecifier(throwing))
			}
		}

		if case let .function(_, returns, _) = signature.kind, let returns {
			line.space()
			line.token("->")
			line.token(renderedType(returns))
		}
	}
}

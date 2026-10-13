//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum FunctionRenderer {
	static func render(_ function: FunctionDescriptor, to writer: inout CodeFileWriter) {
		CodeRenderingSupport.renderDocComment(for: function.signature, to: &writer)

		writer.writeLine { line in
			renderSignature(function.signature, to: &line)
			line.space()
			line.punctuation("{")
		}
		writer.indented { writer in
			StatementRenderer.render(function.body.statements, to: &writer)
		}
		writer.writeLine("}")
	}

	static func renderSignature(_ signature: FunctionSignatureDescriptor, to writer: inout CodeFileWriter) {
		CodeRenderingSupport.renderDocComment(for: signature, to: &writer)

		writer.writeLine { line in
			renderSignature(signature, to: &line)
		}
	}

	private static func renderSignature(_ signature: FunctionSignatureDescriptor, to line: inout LineWriter) {
		if let accessModifier = signature.accessModifier {
			line.token(CodeRenderingSupport.renderedAccessModifier(accessModifier))
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

		ParametersListRenderer.render(signature.parameters, into: &line)

		if !signature.effects.hasEffects {
			line.space()

			if signature.effects.isAsync {
				line.token("async")
			}

			if let throwing = signature.effects.throwingSpecifier {
				line.token(CodeRenderingSupport.renderedThrowingSpecifier(throwing))
			}
		}

		if case let .function(_, returns, _) = signature.kind, let returns {
			line.space()
			line.token("->")
			line.token(CodeRenderingSupport.renderedType(returns))
		}
	}
}

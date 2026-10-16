//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum FunctionRenderer {
	static func render(_ function: FunctionDescriptor, to writer: inout CodeWriter) {
		renderDocComment(for: function.signature, to: &writer)

		writer.writeLine { line in
			renderSignature(function.signature, to: &line)
			line.space()
			line.punctuation(.leftBrace)
		}
		writer.indented { writer in
			StatementRenderer.render(function.body.statements, to: &writer)
		}
		writer.writeLine("}")
	}

	static func renderSignature(_ signature: FunctionSignatureDescriptor, to writer: inout CodeWriter) {
		renderDocComment(for: signature, to: &writer)

		writer.writeLine { line in
			renderSignature(signature, to: &line)
		}
	}

	private static func renderDocComment(for signature: FunctionSignatureDescriptor, to writer: inout CodeWriter) {
		guard let comment = signature.comment else { return }
		CommentRenderer.renderDocComment(comment, to: &writer)

		// As long as one parameter has a comment, the parameters comment list will be generated
		guard signature.parameters.contains(where: { $0.comment != nil }) else { return }

		writer.writeLine("///")
		if signature.parameters.count == 1, let param = signature.parameters.first, let comment = param.comment {
			writer.writeLine("- Parameter \(SwiftIdentifier.sanitized(param.identifier)): \(comment.value)", prefix: "/// ")
		} else {
			writer.writeLine("/// - Parameters:")
			for param in signature.parameters {
				// The parameter will get rendered into the list, whether it has a comment or not, to guarantee
				// valid DocC is generated.
				let comment = param.comment?.value ?? ""
				writer.writeLine("- \(SwiftIdentifier.sanitized(param.identifier)): \(comment)", prefix: "///   ")
			}
		}
	}

	private static func renderSignature(_ signature: FunctionSignatureDescriptor, to line: inout LineWriter) {
		for attribute in signature.attributes {
			AttributeRenderer.render(attribute, to: &line)
		}

		if let accessModifier = signature.accessModifier {
			line.token(CodeRenderingSupport.renderedAccessModifier(accessModifier))
		}

		switch signature.kind {
		case let .initializer(failable):
			line.token("init")
			if failable {
				line.punctuation(.questionMark)
			}
		case let .function(name, _, isStatic):
			if isStatic {
				line.token("static")
			}
			line.token("func")
			line.token(SwiftIdentifier.sanitized(name))
		case let .subscript(_, isStatic):
			if isStatic {
				line.token("static")
			}
			line.token("subscript")
		}

		CodeRenderingSupport.renderGenericSignature(signature.genericParameters, to: &line)
		ParametersListRenderer.render(signature.parameters, into: &line)

		if signature.effects.hasEffects {
			line.space()

			let effects = CodeRenderingSupport.renderedEffects(signature.effects)
			line.token(effects)
		}

		let returns: TypeReference? = switch signature.kind {
			case .initializer: nil
			case let .function(_, returns, _): returns
			case let .subscript(returns, _): returns
		}

		if let returns {
			line.space()
			line.punctuation(.arrow)
			line.space()
			line.token(CodeRenderingSupport.renderedType(returns))
		}

		CodeRenderingSupport.renderGenericRequirements(signature.genericRequirements, to: &line)
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum FunctionRenderer {
	static func render(_ function: FunctionDescriptor, to writer: inout CodeWriter) {
		renderDocComment(for: function.signature, to: &writer)

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

	static func renderSignature(_ signature: FunctionSignatureDescriptor, to writer: inout CodeWriter) {
		renderDocComment(for: signature, to: &writer)

		writer.writeLine { line in
			renderSignature(signature, to: &line)
		}
	}

	private static func renderDocComment(for signature: FunctionSignatureDescriptor, to writer: inout CodeWriter) {
		guard let docComment = signature.comment else { return }

		writer.writeLine(docComment.value, prefix: "/// ")

		let paramsWithComments = signature.parameters.filter { $0.comment != nil }
		guard !paramsWithComments.isEmpty else { return }

		writer.writeLine("///")
		if paramsWithComments.count == 1, let param = paramsWithComments.first, let comment = param.comment {
			writer.writeLine("- Parameter \(SwiftIdentifier.sanitized(param.identifier)): \(comment.value)", prefix: "/// ")
		} else {
			writer.writeLine("/// - Parameters:")
			for param in paramsWithComments {
				if let comment = param.comment {
					writer.writeLine("- \(SwiftIdentifier.sanitized(param.identifier)): \(comment.value)", prefix: "///   ")
				}
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
				line.punctuation("?")
			}
		case let .function(name, _, isStatic):
			if isStatic {
				line.token("static")
			}
			line.token("func")
			line.token(SwiftIdentifier.sanitized(name))
		}

		ParametersListRenderer.render(signature.parameters, into: &line)

		if signature.effects.hasEffects {
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

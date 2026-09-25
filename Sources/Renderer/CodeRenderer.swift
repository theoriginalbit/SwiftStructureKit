//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

class CodeRenderer {
	var writer: CodeFileWriter

	init(indentUsing style: CodeIndentStyle = .spaces(4)) {
		self.writer = CodeFileWriter(indentUsing: style)
	}

	func finish() -> Data {
		var extracted = CodeFileWriter()
		swap(&extracted, &writer)
		return extracted.rendered()
	}

	// MARK: - Functions that render to the writer

	func renderFunction(_ function: FunctionDescriptor) {
		renderFunctionSignature(function.signature, hasBody: function.body != nil)
		if let body = function.body {
			renderCodeBlock(body)
			writer.writeLine("}")
		}
	}

	func renderFunctionSignature(_ signature: FunctionSignatureDescriptor, hasBody: Bool = false) {
		renderDocComment(for: signature)

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

	func renderCodeBlock(_ codeBlock: CodeBlockDescriptor) {
		guard !codeBlock.statements.isEmpty else {
			return
		}
		writer.indented { writer in
			renderStatements(codeBlock.statements, to: &writer)
		}
	}

	func renderStatements(_ statements: [StatementDescriptor]) {
		renderStatements(statements, to: &writer)
	}

	func renderStatements(_ statements: [StatementDescriptor], to writer: inout CodeFileWriter) {
		for statement in statements {
			renderStatement(statement, to: &writer)
		}
	}

	func renderStatement(_ statement: StatementDescriptor) {
		renderStatement(statement, to: &writer)
	}

	func renderStatement(_ statement: StatementDescriptor, to writer: inout CodeFileWriter) {
		writer.writeLine { line in
			switch statement.kind {
			case let .assignment(isMutable, identifier, type, expression):
				line.token(isMutable ? "var" : "let")
				line.token(identifier)
				line.punctuation(":")
				line.space()
				line.token(renderedType(type))
				if let expression {
					line.space()
					line.punctuation("=")
					line.space()
					line.token(renderedExpression(expression))
				}
			case let .return(expression):
				line.token("return")
				if let expression {
					line.token(renderedExpression(expression))
				}
			}
		}
	}

	func renderDocComment(for signature: FunctionSignatureDescriptor) {
		guard let docComment = signature.comment else { return }

		writer.writeLine(docComment.value, prefix: "/// ")

		let paramsWithComments = signature.parameters.filter { $0.comment != nil }
		guard !paramsWithComments.isEmpty else { return }

		writer.writeLine("///")
		if paramsWithComments.count == 1, let param = paramsWithComments.first, let comment = param.comment {
			writer.writeLine("- Parameter \(param.identifier): \(comment.value)", prefix: "/// ")
		} else {
			writer.writeLine("/// - Parameters:")
			for param in paramsWithComments {
				if let comment = param.comment {
					writer.writeLine("- \(param.identifier): \(comment.value)", prefix: "///   ")
				}
			}
		}
	}

	func renderParametersList(_ parametersList: ParametersList) {
		writer.writeLine { line in
			renderParametersList(parametersList, into: &line)
		}
	}

	func renderParametersList(_ parametersList: ParametersList, into line: inout LineWriter) {
		line.punctuation("(")
		for (index, param) in parametersList.parameters.enumerated() {
			renderParameter(param, into: &line)
			if index < parametersList.parameters.endIndex - 1 {
				line.punctuation(",")
				line.space()
			}
		}
		line.punctuation(")")
	}

	func renderParameter(_ parameter: ParametersList.Parameter, into writer: inout LineWriter) {
		if let label = parameter.label, label != parameter.identifier {
			writer.token(label)
		}
		writer.token(parameter.identifier)
		writer.punctuation(":")
		writer.space()
		writer.token(renderedType(parameter.type))
		if let defaultValue = parameter.defaultValue {
			writer.space()
			writer.punctuation("=")
			writer.space()
			writer.token(renderedExpression(defaultValue))
		}
	}

	// MARK: - Functions that provide values to the render functions

	func renderedThrowingSpecifier(_ specifier: EffectSpecifiers.ThrowingSpecifier) -> String {
		switch specifier {
		case .throws:
			return "throws"
		case .rethrows:
			return "rethrows"
		case let .typed(type):
			return "throws(\(renderedType(type)))"
		}
	}

	func renderedAccessModifier(_ accessModifier: AccessModifierDescriptor) -> String {
		switch accessModifier {
		case .open: "open"
		case .public: "public"
		case .package: "package"
		case .internal: "internal" // TODO: config setting to not render explicit internal
		case .fileprivate: "fileprivate"
		case .private: "private"
		}
	}

	func renderedExpression(_ expression: ExpressionDescriptor) -> String {
		switch expression.kind {
		case let .literal(literal):
			return renderedLiteral(literal)
		}
	}

	func renderedLiteral(_ literal: LiteralDescriptor) -> String {
		return switch literal {
		case let .string(value):
			if value.contains(where: \.isNewline) {
				// it contains a newline so we should emit a multiline; multiline inception!
				#"""
				"""
				\#(value)
				"""
				"""#
			} else {
				#""\#(value)""#
			}
		case let .integer(value):
			String(value)
		case let .boolean(value):
			String(value)
		case let .double(value):
			String(value)
		case .nil:
			"nil"
		}
	}

	func renderedType(_ type: TypeReference) -> String {
		return switch type {
		case let .type(value):
			value
		case let .array(element):
			"Array<\(renderedType(element))>"
		case let .dictionary(key, value):
			"Dictionary<\(renderedType(key)), \(renderedType(value))>"
		case let .optional(value):
			"Optional<\(renderedType(value))>"
		}
	}
}

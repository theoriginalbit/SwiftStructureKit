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

	// MARK: - Functions that render common types to the writer

	func renderTypeMember(_ member: TypeMemberDescriptor) {
		renderTypeMember(member, to: &writer)
	}

	func renderTypeMember(_ member: TypeMemberDescriptor, to writer: inout CodeFileWriter) {
		switch member {
		case let .function(function):
			renderFunction(function, to: &writer)
		}
	}

	func renderCodeBlock(_ codeBlock: CodeBlockDescriptor) {
		renderCodeBlock(codeBlock, to: &writer)
	}

	func renderCodeBlock(_ codeBlock: CodeBlockDescriptor, to writer: inout CodeFileWriter) {
		guard !codeBlock.statements.isEmpty else {
			return
		}
		writer.indented { writer in
			renderStatements(codeBlock.statements, to: &writer)
		}
	}

	func renderDocComment(for signature: FunctionSignatureDescriptor) {
		renderDocComment(for: signature, to: &writer)
	}

	func renderDocComment(for signature: FunctionSignatureDescriptor, to writer: inout CodeFileWriter) {
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

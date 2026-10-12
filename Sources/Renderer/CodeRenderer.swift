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

	func renderGenericSignature(
		_ genericTypes: [TypeReference],
		to line: inout LineWriter,
	) {
		guard !genericTypes.isEmpty else { return }
		line.punctuation("<")
		line.token(renderedTypesList(genericTypes))
		line.punctuation(">")
	}

	func renderTypeSignature(
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		typeKeyword: String,
		identifier: String,
		genericTypes: [TypeReference],
		conformances: [TypeReference],
		to writer: inout CodeFileWriter,
	) {
		if let comment = comment {
			writer.writeLine(comment.value, prefix: "/// ")
		}

		writer.writeLine { line in
			if let accessModifier = accessModifier {
				line.token(renderedAccessModifier(accessModifier))
			}

			line.token(typeKeyword)

			line.token(identifier)

			renderGenericSignature(genericTypes, to: &line)

			if !conformances.isEmpty {
				line.punctuation(":")
				line.space()
				line.token(renderedTypesList(conformances))
			}

			line.space()
			line.punctuation("{")
		}
	}

	func renderTypeMembers(_ members: TypeMembersBuilder.Result, to writer: inout CodeFileWriter) {
		guard !members.isEmpty else { return }
		writer.indented { writer in
			for (index, member) in members.enumerated() {
				renderTypeMember(member, to: &writer)
				if index < members.count - 1 {
					writer.writeNewLine()
				}
			}
		}
	}

	func renderTypeMember(_ member: TypeMemberDescriptor, to writer: inout CodeFileWriter) {
		switch member {
		case let .function(descriptor):
			renderFunction(descriptor, to: &writer)
		case let .enum(descriptor):
			renderEnum(descriptor, to: &writer)
		case let .struct(descriptor):
			renderStruct(descriptor, to: &writer)
		case let .mark(descriptor):
			renderMarkComment(descriptor, to: &writer)
		case let .diagnostic(descriptor):
			renderDiagnosticDirective(descriptor, to: &writer)
		}
	}

	func renderCodeBlock(_ codeBlock: CodeBlockDescriptor, to writer: inout CodeFileWriter) {
		guard !codeBlock.statements.isEmpty else {
			return
		}
		writer.indented { writer in
			renderStatements(codeBlock.statements, to: &writer)
		}
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

	func renderMarkComment(_ descriptor: MarkCommentDescriptor, to writer: inout CodeFileWriter) {
		writer.writeLine { line in
			line.token("// MARK:")
			if descriptor.sectionBreak {
				line.space()
				line.punctuation("-")
				line.space()
			}
			if let value = descriptor.value {
				line.token(value)
			}
		}
	}

	func renderInlineComment(_ descriptor: InlineCommentDescriptor, to writer: inout CodeFileWriter) {
		writer.writeLine(descriptor.value, prefix: "// ")
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

	@inlinable func renderedType(_ type: TypeReference) -> String {
		type.sourceIdentifier
	}

	func renderedTypesList(_ types: [TypeReference]) -> String {
		types.lazy
			.map(renderedType(_:))
			.joined(separator: ", ")
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Collections

enum CodeRenderingSupport {
	static func renderGenericSignature(
		_ genericTypes: OrderedSet<TypeReference>,
		to line: inout LineWriter,
	) {
		guard !genericTypes.isEmpty else { return }
		line.punctuation("<")
		line.token(renderedTypesList(genericTypes))
		line.punctuation(">")
	}

	static func renderTypeSignature(
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		typeKeyword: String,
		identifier: String,
		genericTypes: OrderedSet<TypeReference>,
		conformances: OrderedSet<TypeReference>,
		to writer: inout CodeFileWriter,
	) {
		if let comment {
			writer.writeLine(comment.value, prefix: "/// ")
		}

		writer.writeLine { line in
			if let accessModifier {
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

	static func renderDocComment(for signature: FunctionSignatureDescriptor, to writer: inout CodeFileWriter) {
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

	static func renderMarkComment(_ descriptor: MarkCommentDescriptor, to writer: inout CodeFileWriter) {
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

	static func renderInlineComment(_ descriptor: InlineCommentDescriptor, to writer: inout CodeFileWriter) {
		writer.writeLine(descriptor.value, prefix: "// ")
	}

	static func renderedThrowingSpecifier(_ specifier: EffectSpecifiers.ThrowingSpecifier) -> String {
		switch specifier {
		case .throws:
			return "throws"
		case .rethrows:
			return "rethrows"
		case let .typed(type):
			return "throws(\(renderedType(type)))"
		}
	}

	static func renderedAccessModifier(_ accessModifier: AccessModifierDescriptor) -> String {
		switch accessModifier {
		case .open: "open"
		case .public: "public"
		case .package: "package"
		case .internal: "internal" // TODO: config setting to not render explicit internal
		case .fileprivate: "fileprivate"
		case .private: "private"
		}
	}

	static func renderedExpression(_ expression: ExpressionDescriptor) -> String {
		switch expression.kind {
		case let .literal(literal):
			return renderedLiteral(literal)
		}
	}

	static func renderedLiteral(_ literal: LiteralDescriptor) -> String {
		return switch literal {
		case let .string(value):
			if value.contains(where: \.isNewline) {
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

	@inlinable static func renderedType(_ type: TypeReference) -> String {
		type.sourceIdentifier
	}

	static func renderedTypesList(_ types: OrderedSet<TypeReference>) -> String {
		types.lazy
			.map(renderedType(_:))
			.joined(separator: ", ")
	}
}

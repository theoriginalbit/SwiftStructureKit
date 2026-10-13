//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Collections

enum CodeRenderingSupport {
	// MARK: Common rendering

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
		to writer: inout CodeWriter,
	) {
		if let comment {
			writer.writeLine(comment.value, prefix: "/// ")
		}

		writer.writeLine { line in
			if let accessModifier {
				line.token(renderedAccessModifier(accessModifier))
			}

			line.token(typeKeyword)
			line.token(SwiftIdentifier.sanitized(identifier))
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

	// MARK: Rendered to string

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
		case .internal: "internal"
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

	static func renderedType(_ type: TypeReference) -> String {
		return switch type {
		case let .identifier(identifier):
			SwiftIdentifier.sanitized(identifier)
		case let .array(element):
			"Array<\(renderedType(element))>"
		case let .dictionary(key, value):
			"Dictionary<\(renderedType(key)), \(renderedType(value))>"
		case let .optional(value):
			"Optional<\(renderedType(value))>"
		case let .any(value):
			"any \(renderedType(value))"
		case let .some(value):
			"some \(renderedType(value))"
		case let .tuple(elements):
			"(\(elements.map(rendered(_:)).joined(separator: ", ")))"
		case let .closure(parameters, returns):
			"(\(parameters.map(renderedType(_:)).joined(separator: ", "))) -> \(renderedType(returns))"
		case let .genericParameter(name, constraints):
			if constraints.isEmpty {
				SwiftIdentifier.sanitized(name)
			} else {
				"\(SwiftIdentifier.sanitized(name)): \(constraints.map(renderedType(_:)).joined(separator: " & "))"
			}
		}
	}

	static func rendered(_ element: TupleElementDescriptor) -> String {
		let type = renderedType(element.type)
		guard let label = element.label else { return type }
		return "\(SwiftIdentifier.sanitized(label)): \(type)"
	}

	static func renderedTypesList(_ types: OrderedSet<TypeReference>) -> String {
		types.lazy
			.map(renderedType(_:))
			.joined(separator: ", ")
	}
}

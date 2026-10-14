//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import OrderedCollections

enum CodeRenderingSupport {
	// MARK: Common rendering

	static func renderGenericSignature(
		_ genericParameters: OrderedSet<GenericParameterDescriptor>,
		to line: inout LineWriter,
	) {
		guard !genericParameters.isEmpty else { return }
		line.punctuation("<")
		line.token(genericParameters.map(renderedGenericParameter(_:)).joined(separator: ", "))
		line.punctuation(">")
	}

	static func renderGenericRequirements(
		_ requirements: [TypeConstraintDescriptor],
		to line: inout LineWriter,
	) {
		guard !requirements.isEmpty else { return }
		line.space()
		line.token("where")
		line.token(requirements.map(renderedConstraint(_:)).joined(separator: ", "))
	}

	static func renderTypeSignature(
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		attributes: [AttributeDescriptor],
		typeKeyword: String,
		identifier: String,
		genericParameters: OrderedSet<GenericParameterDescriptor>,
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: OrderedSet<TypeReference>,
		to writer: inout CodeWriter,
	) {
		if let comment {
			writer.writeLine(comment.value, prefix: "/// ")
		}
		AttributeRenderer.render(attributes, to: &writer)

		writer.writeLine { line in
			if let accessModifier {
				line.token(renderedAccessModifier(accessModifier))
			}

			line.token(typeKeyword)
			line.token(SwiftIdentifier.sanitized(identifier))
			renderGenericSignature(genericParameters, to: &line)

			if !conformances.isEmpty {
				line.punctuation(":")
				line.space()
				line.token(renderedTypesList(conformances))
			}

			renderGenericRequirements(genericRequirements, to: &line)
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
			renderedIdentifier(identifier)
		case let .generic(identifier, arguments):
			"\(renderedIdentifier(identifier))<\(renderedTypesList(arguments))>"
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
		case let .closure(parameters, returns, isEscaping, attributes, effects):
			renderedClosure(
				parameters: parameters,
				returns: returns,
				isEscaping: isEscaping,
				attributes: attributes,
				effects: effects
			)
		}
	}

	private static func renderedClosure(
		parameters: [TypeReference],
		returns: TypeReference,
		isEscaping: Bool,
		attributes: OrderedSet<AttributeDescriptor>,
		effects: EffectSpecifiers,
	) -> String {
		var attributes = attributes
		if isEscaping {
			attributes.append(.rawValue("escaping"))
		}

		var writer = TokenWriter()
		for attribute in attributes {
			writer.write(AttributeRenderer.rendered(attribute))
			writer.space()
		}

		writer.write("(")
		writer.write(renderedTypesList(parameters))
		writer.write(")")
		if effects.hasEffects {
			writer.space()
			writer.write(renderedEffects(effects))
		}

		writer.write(" -> ")
		writer.write(renderedType(returns))

		return writer.finish()
	}

	static func renderedEffects(_ effects: EffectSpecifiers) -> String {
		var writer = TokenWriter()
		if effects.isAsync {
			writer.write("async")
		}
		if let throwingSpecifier = effects.throwingSpecifier {
			if effects.isAsync {
				writer.space()
			}
			writer.write(renderedThrowingSpecifier(throwingSpecifier))
		}
		return writer.finish()
	}

	static func renderedIdentifier(_ identifier: TypeIdentifier) -> String {
		identifier.components.map(SwiftIdentifier.sanitized(_:)).joined(separator: ".")
	}

	static func renderedGenericParameter(_ parameter: GenericParameterDescriptor) -> String {
		let identifier = renderedIdentifier(parameter.identifier)
		guard let constraint = parameter.constraint else { return identifier }
		return "\(identifier): \(renderedComposition(constraint))"
	}

	static func renderedConstraint(_ constraint: TypeConstraintDescriptor) -> String {
		"\(renderedIdentifier(constraint.type)): \(renderedComposition(constraint.constraint))"
	}

	static func rendered(_ element: TupleElementDescriptor) -> String {
		let type = renderedType(element.type)
		guard let label = element.label else { return type }
		return "\(SwiftIdentifier.sanitized(label)): \(type)"
	}

	static func renderedTypesList(_ types: some Collection<TypeReference>) -> String {
		types.lazy
			.map(renderedType(_:))
			.joined(separator: ", ")
	}

	static func renderedComposedTypes(_ types: some Collection<TypeReference>) -> String {
		types.lazy
			.map(renderedType(_:))
			.joined(separator: " & ")
	}

	static func renderedComposition(_ composition: TypeComposition) -> String {
		renderedComposedTypes(composition.types)
	}
}

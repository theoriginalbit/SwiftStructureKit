//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

enum CodeRenderingSupport {
	// MARK: Common rendering

	static func renderGenericSignature(
		_ genericParameters: [GenericParameterDescriptor],
		to line: inout LineWriter,
	) {
		guard !genericParameters.isEmpty else { return }
		line.punctuation(.leftAngle)

		// track identifiers that have been rendered to de-duplicate
		var seen: Set<TypeIdentifier> = []
		for (index, genericParameter) in genericParameters.enumerated() {
			if seen.contains(genericParameter.identifier) { continue }
			seen.insert(genericParameter.identifier)
			if index > 0 {
				// not the first one, need to render another one, add the comma
				// since we don't know if the next token is a duplicate or not
				line.punctuation(.comma)
			}
			line.token(renderedGenericParameter(genericParameter))
		}
		line.punctuation(.rightAngle)
	}

	static func renderGenericRequirements(
		_ requirements: [TypeConstraintDescriptor],
		to line: inout LineWriter,
	) {
		guard !requirements.isEmpty else { return }
		line.token("where")
		line.token(requirements.map(renderedConstraint(_:)).joined(separator: ", "))
	}

	static func renderTypeDeclaration(
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		attributes: [AttributeDescriptor],
		typeKeyword: String,
		identifier: String,
		genericParameters: [GenericParameterDescriptor],
		genericRequirements: [TypeConstraintDescriptor] = [],
		conformances: [TypeReference],
		to writer: inout CodeWriter,
		body: (inout CodeWriter) -> Void,
	) {
		CommentRenderer.renderDocComment(comment, to: &writer)
		AttributeRenderer.render(attributes, to: &writer)

		writer.writeLine { line in
			if let accessModifier {
				line.token(renderedAccessModifier(accessModifier))
			}

			line.token(typeKeyword)
			line.token(SwiftIdentifier.sanitized(identifier))
			renderGenericSignature(genericParameters, to: &line)

			if !conformances.isEmpty {
				line.punctuation(.colon)
				let conformances = conformances.removingDuplicates()
				line.token(renderedTypesList(conformances))
			}

			renderGenericRequirements(genericRequirements, to: &line)
			line.block(body)
		}
	}

	// MARK: Rendered to string

	static func renderedThrowingSpecifier(_ specifier: ThrowingSpecifier) -> String {
		switch specifier {
		case .throws:
			return "throws"
		case let .typed(type):
			return "throws(\(renderedType(type)))"
		}
	}

	static func renderedThrowingSpecifier(_ specifier: FunctionThrowingSpecifier) -> String {
		switch specifier {
		case .throws:
			return renderedThrowingSpecifier(ThrowingSpecifier.throws)
		case .rethrows:
			return "rethrows"
		case let .typed(type):
			return renderedThrowingSpecifier(ThrowingSpecifier.typed(type))
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
		switch expression {
		case let .literal(literal):
			return renderedLiteral(literal)
		case let .raw(value):
			return value
		case let .functionCall(callee, arguments):
			let renderedArguments = arguments.map { argument in
				let expression = renderedExpression(argument.value)
				return if let label = argument.label {
					"\(SwiftIdentifier.sanitized(label)): \(expression)"
				} else {
					expression
				}
			}
			return "\(renderedExpression(callee))(\(renderedArguments.joined(separator: ", ")))"
		case let .identifier(identifier):
			return renderedIdentifier(identifier)
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
		case .array:
			"[]"
		case .dictionary:
			"[:]"
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
		attributes: [AttributeDescriptor],
		effects: EffectSpecifiers<ThrowingSpecifier>,
	) -> String {
		var attributes = attributes
		if isEscaping {
			attributes.append(.escaping)
		}

		var writer = TokenWriter()

		// We can only de-duplicate once the attribute has been rendered since
		// AttributeDescriptor offers .rawValue which could dupe a convenience
		// type. Performing de-dupe here also handles the scenario where a
		// consumer could have supplied .rawValue("A") and .rawValue("@A")
		// which would also have not been considered a duplicate.
		var seen: Set<String> = []
		for attribute in attributes {
			let rendered = AttributeRenderer.rendered(attribute)
			if seen.contains(rendered) { continue }
			seen.insert(rendered)
			writer.write(rendered)
		}

		writer.write("(", acceptsSpaceAfter: false) // not standard ( punctuation, this accepts space before
		writer.write(renderedTypesList(parameters))
		writer.write(.rightParen)
		if effects.hasEffects {
			writer.write(renderedEffects(effects))
		}

		writer.write(.arrow)
		writer.write(renderedType(returns))

		return writer.finish()
	}

	static func renderedEffects(_ effects: EffectSpecifiers<ThrowingSpecifier>) -> String {
		renderedEffects(effects, renderThrowingSpecifier: renderedThrowingSpecifier)
	}

	static func renderedEffects(_ effects: EffectSpecifiers<FunctionThrowingSpecifier>) -> String {
		renderedEffects(effects, renderThrowingSpecifier: renderedThrowingSpecifier)
	}

	private static func renderedEffects<Throwing: Hashable & Sendable>(
		_ effects: EffectSpecifiers<Throwing>,
		renderThrowingSpecifier: (Throwing) -> String,
	) -> String {
		var writer = TokenWriter()
		if effects.isAsync {
			writer.write("async")
		}
		if let throwingSpecifier = effects.throwingSpecifier {
			writer.write(renderThrowingSpecifier(throwingSpecifier))
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

	static func renderedComposition(_ types: some Collection<TypeReference>) -> String {
		types.lazy
			.map(renderedType(_:))
			.removingDuplicates()
			.joined(separator: " & ")
	}

	static func renderedComposition(_ composition: TypeComposition) -> String {
		renderedComposition(composition.types)
	}
}

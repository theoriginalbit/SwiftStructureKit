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
		line.token(TokenWriter.render { writer in
			var iterator = requirements.makeIterator()
			if let first = iterator.next() {
				writer.write(renderedConstraint(first))
				while let next = iterator.next() {
					writer.write(.comma)
					writer.write(renderedConstraint(next))
				}
			}
		})
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
		renderTypeDeclaration(
			comment: comment,
			accessModifier: accessModifier,
			attributes: attributes,
			typeKeyword: typeKeyword,
			identifier: .identifier([identifier]), // pass as components to avoid splitting by '.' and let the sanitizer replace
			genericParameters: genericParameters,
			genericRequirements: genericRequirements,
			conformances: conformances,
			to: &writer,
			body: body
		)
	}

	static func renderTypeDeclaration(
		comment: DocCommentDescriptor?,
		accessModifier: AccessModifierDescriptor?,
		attributes: [AttributeDescriptor],
		typeKeyword: String,
		identifier: TypeReference,
		genericParameters: [GenericParameterDescriptor],
		genericRequirements: [TypeConstraintDescriptor],
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
			line.token(renderedType(identifier))
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
			return TokenWriter.render { writer in
				writer.write("throws")
				writer.write(.leftParen)
				writer.write(renderedType(type))
				writer.write(.rightParen)
			}
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
		case .public: "public"
		case .package: "package"
		case .internal: "internal"
		case .fileprivate: "fileprivate"
		case .private: "private"
		}
	}

	static func renderUnaryKeyword(_ descriptor: UnaryKeywordDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			switch descriptor {
			case let .return(expression):
				line.token("return")
				if let expression {
					ExpressionRenderer.render(expression, to: &line)
				}
			case let .try(hasPostfixQuestionMark, expression):
				line.token("try")
				if hasPostfixQuestionMark {
					line.punctuation(.questionMark)
				}
				ExpressionRenderer.render(expression, to: &line)
			case let .await(expression):
				line.token("await")
				ExpressionRenderer.render(expression, to: &line)
			case let .throw(expression):
				line.token("throw")
				ExpressionRenderer.render(expression, to: &line)
			case .continue:
				line.token("continue")
			case .break:
				line.token("break")
			}
		}
	}

	static func renderedLiteral(_ literal: LiteralDescriptor) -> String {
		return switch literal {
		case let .string(value):
			renderedStringLiteral(value)
		case let .integer(value):
			String(value)
		case let .boolean(value):
			String(value)
		case let .double(value):
			renderedDouble(value)
		case .nil:
			"nil"
		case .array:
			emptyArray
		case .dictionary:
			emptyDictionary
		}
	}

	private static func renderedStringLiteral(_ value: String) -> String {
		if value.contains(where: \.isNewline) {
   #"""
   """
   \#(value)
   """
   """#
		} else {
			#""\#(value)""#
		}
	}

	private static func renderedDouble(_ value: Double) -> String {
		var writer = TokenWriter()
		if value.isNaN {
			writer.write(value.isSignalingNaN ? "Double.signalingNaN" : "Double.nan")
			return writer.finish()
		}
		if value.sign == .minus {
			writer.write(.minus)
		}
		let rendered = switch value.magnitude {
		case .infinity: "Double.infinity"
		case .pi: "Double.pi"
		case .zero: "Double.zero"
		case .ulpOfOne: "Double.ulpOfOne"
		case .greatestFiniteMagnitude: "Double.greatestFiniteMagnitude"
		case .leastNonzeroMagnitude: "Double.leastNonzeroMagnitude"
		case .leastNormalMagnitude: "Double.leastNormalMagnitude"
		default: String(value.magnitude)
		}
		writer.write(rendered)
		return writer.finish()
	}

	private static let emptyArray = TokenWriter.render { writer in
		writer.write(.leftBracket)
		writer.write(.rightBracket)
	}

	private static let emptyDictionary = TokenWriter.render { writer in
		writer.write(.leftBracket)
		writer.write(.colon)
		writer.write(.rightBracket)
	}

	static func renderedType(_ type: TypeReference) -> String {
		return switch type {
		case let .identifier(identifier):
			renderedIdentifier(identifier, as: .type)
		case let .generic(identifier, arguments):
			renderedGenericTypeIdentifier(renderedIdentifier(identifier, as: .type), arguments)
		case let .array(element):
			renderedGenericTypeIdentifier("Array", [element])
		case let .dictionary(key, value):
			renderedGenericTypeIdentifier("Dictionary", [key, value])
		case let .optional(value):
			renderedGenericTypeIdentifier("Optional", [value])
		case let .any(value):
			"any \(renderedType(value))"
		case let .some(value):
			"some \(renderedType(value))"
		case let .tuple(elements):
			renderedTupleSignature(elements)
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

	private static func renderedGenericTypeIdentifier(_ type: String, _ types: [TypeReference]) -> String {
		var writer = TokenWriter()
		writer.write(type)
		writer.write(.leftAngle)
		writer.write(renderedTypesList(types))
		writer.write(.rightAngle)
		return writer.finish()
	}

	private static func renderedTupleSignature(
		_ elements: [TupleElementDescriptor]
	) -> String {
		var writer = TokenWriter()
		writer.write(.leftParen)
		var iterator = elements.makeIterator()
		if let first = iterator.next() {
			writer.write(renderedTupleSignatureElement(first))
			while let next = iterator.next() {
				writer.write(.comma)
				writer.write(renderedTupleSignatureElement(next))
			}
		}
		writer.write(.rightParen)
		return writer.finish()
	}

	private static func renderedTupleSignatureElement(_ element: TupleElementDescriptor) -> String {
		let type = renderedType(element.type)
		guard let label = element.label else { return type }
		return "\(SwiftIdentifier.sanitized(label, position: .argumentLabel)): \(type)"
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
		var seenAttributes: Set<String> = []
		for attribute in attributes {
			let rendered = AttributeRenderer.rendered(attribute)
			if seenAttributes.contains(rendered) { continue }
			seenAttributes.insert(rendered)
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

	private static func renderedEffects<Throwing: ThrowingSpecifierDescriptor>(
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

	/// The syntactic role of a qualified identifier, which decides how each component is escaped.
	enum IdentifierContext {
		/// A value expression such as `self.$binding` or `Color.default`.
		case expression

		/// A type name such as `Foundation.Date`.
		case type

		fileprivate var leadingPosition: SwiftIdentifier.Position {
			switch self {
			case .expression: .reference
			case .type: .type
			}
		}

		fileprivate var trailingPosition: SwiftIdentifier.Position {
			switch self {
			case .expression: .memberAccess
			case .type: .nestedType
			}
		}
	}

	static func renderedIdentifier(_ identifier: TypeIdentifier, as context: IdentifierContext = .expression) -> String {
		var iterator = identifier.components.makeIterator()
		guard let first = iterator.next() else {
			return ""
		}
		var writer = TokenWriter()
		writer.write(SwiftIdentifier.sanitized(first, position: context.leadingPosition))
		while let next = iterator.next() {
			writer.write(.period)
			writer.write(SwiftIdentifier.sanitized(next, position: context.trailingPosition))
		}
		return writer.finish()
	}

	static func renderedGenericParameter(_ parameter: GenericParameterDescriptor) -> String {
		var writer = TokenWriter()
		let identifier = renderedIdentifier(parameter.identifier, as: .type)
		writer.write(identifier)
		if let constraint = parameter.constraint {
			writer.write(.colon)
			writer.write(renderedComposition(constraint))
		}
		return writer.finish()
	}

	static func renderedConstraint(_ constraint: TypeConstraintDescriptor) -> String {
		var writer = TokenWriter()
		writer.write(renderedIdentifier(constraint.type, as: .type))
		switch constraint.kind {
		case let .conformsTo(composition):
			writer.write(.colon)
			writer.write(renderedComposition(composition))
		case let .sameType(composition):
			writer.write(.equals)
			writer.write(renderedComposition(composition))
		}
		return writer.finish()
	}

	static func renderedTypesList(_ types: some Collection<TypeReference>) -> String {
		var iterator = types.makeIterator()
		guard let first = iterator.next() else {
			return ""
		}
		var writer = TokenWriter()
		writer.write(renderedType(first))

		while let next = iterator.next() {
			writer.write(.comma)
			writer.write(renderedType(next))
		}
		return writer.finish()
	}

	static func renderedComposition(_ types: some Collection<TypeReference>) -> String {
		var iterator = types.makeIterator()
		guard let first = iterator.next() else {
			return ""
		}
		var writer = TokenWriter()
		writer.write(renderedType(first))

		var seen: Set<TypeReference> = [first]
		while let next = iterator.next() {
			if seen.contains(next) {
				continue
			}
			seen.insert(next)
			writer.write(.ampersand)
			writer.write(renderedType(next))
		}
		return writer.finish()
	}

	static func renderedComposition(_ composition: TypeComposition) -> String {
		renderedComposition(composition.types)
	}
}

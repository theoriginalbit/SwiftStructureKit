//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum PropertyRenderer {
	static func render(_ property: PropertyDescriptor, to writer: inout CodeWriter) {
		CommentRenderer.renderDocComment(property.comment, to: &writer)
		AttributeRenderer.render(property.attributes, to: &writer)

		switch property.kind {
		case let .stored(kind, defaultValue, observers):
			writer.writeLine { line in
				renderDeclarationPrefix(property, to: &line)
				line.token(kind == .var ? "var" : "let")
				line.token(SwiftIdentifier.sanitized(property.identifier))
				line.punctuation(.colon)
				line.token(CodeRenderingSupport.renderedType(property.type))
				if let defaultValue {
					line.punctuation(.equal)
					line.token(ExpressionRenderer.renderedExpression(defaultValue))
				}
				if !observers.isEmpty {
					line.block { writer in
						render(observers, to: &writer)
					}
				}
			}

		case let .computed(getter, setter):
			writer.writeLine { line in
				renderDeclarationPrefix(property, to: &line)
				line.token("var")
				line.token(SwiftIdentifier.sanitized(property.identifier))
				line.punctuation(.colon)
				line.token(CodeRenderingSupport.renderedType(property.type))
				line.block { writer in
					render(getter, hasSetter: setter != nil, to: &writer)
					if let setter {
						render(setter, to: &writer)
					}
				}
			}
		}
	}

	private static func renderDeclarationPrefix(_ property: PropertyDescriptor, to line: inout LineWriter) {
		if let accessModifier = property.accessModifier {
			line.token(CodeRenderingSupport.renderedAccessModifier(accessModifier))
		}
		if property.isStatic {
			line.token("static")
		}
	}

	private static func render(_ getter: PropertyAccessorDescriptor.Getter, hasSetter: Bool, to writer: inout CodeWriter) {
		let requiresExplicitGetBlock = hasSetter || getter.effects.hasEffects
		guard requiresExplicitGetBlock else {
			StatementRenderer.render(getter.body.statements, to: &writer)
			return
		}

		writer.writeLine { line in
			line.token("get")
			if getter.effects.hasEffects {
				line.token(CodeRenderingSupport.renderedEffects(getter.effects))
			}
			line.block(getter.body)
		}
	}

	private static func render(_ setter: PropertyAccessorDescriptor.Setter, to writer: inout CodeWriter) {
		writer.writeLine { line in
			renderAccessorName("set", parameterName: setter.parameterName, to: &line)
			line.block(setter.body)
		}
	}

	private static func render(_ observers: [PropertyAccessorDescriptor.Observer], to writer: inout CodeWriter) {
		for observer in observers {
			writer.writeLine { line in
				switch observer.kind {
				case let .willSet(parameterName):
					renderAccessorName("willSet", parameterName: parameterName, to: &line)
				case let .didSet(parameterName):
					renderAccessorName("didSet", parameterName: parameterName, to: &line)
				}
				line.block(observer.body)
			}
		}
	}

	private static func renderAccessorName(
		_ name: String,
		parameterName: String?,
		to line: inout LineWriter,
	) {
		line.token(name)
		if let parameterName {
			line.punctuation(.leftParen)
			line.token(SwiftIdentifier.sanitized(parameterName))
			line.punctuation(.rightParen)
		}
	}
}

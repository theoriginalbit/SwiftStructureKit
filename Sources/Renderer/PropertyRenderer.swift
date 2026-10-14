//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum PropertyRenderer {
	static func render(_ property: PropertyDescriptor, to writer: inout CodeWriter) {
		if let comment = property.comment {
			writer.writeLine(comment.value, prefix: "/// ")
		}
		AttributeRenderer.render(property.attributes, to: &writer)

		switch property.kind {
		case let .stored(isMutable, defaultValue, observers):
			writer.writeLine { line in
				renderDeclarationPrefix(property, to: &line)
				line.token(isMutable ? "var" : "let")
				line.token(SwiftIdentifier.sanitized(property.identifier))
				line.punctuation(":")
				line.space()
				line.token(CodeRenderingSupport.renderedType(property.type))
				if let defaultValue {
					line.space()
					line.punctuation("=")
					line.space()
					line.token(CodeRenderingSupport.renderedExpression(defaultValue))
				}
				if !observers.isEmpty {
					line.space()
					line.punctuation("{")
				}
			}
			if !observers.isEmpty {
				render(observers, to: &writer)
				writer.writeLine("}")
			}

		case let .computed(getter, setter):
			writer.writeLine { line in
				renderDeclarationPrefix(property, to: &line)
				line.token("var")
				line.token(SwiftIdentifier.sanitized(property.identifier))
				line.punctuation(":")
				line.space()
				line.token(CodeRenderingSupport.renderedType(property.type))
				line.space()
				line.punctuation("{")
			}
			render(getter, to: &writer)
			if let setter {
				render(setter, to: &writer)
			}
			writer.writeLine("}")
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

	private static func render(_ getter: PropertyAccessorDescriptor.Getter, to writer: inout CodeWriter) {
		writer.indented { writer in
			writer.writeLine { line in
				line.token("get")
				render(getter.effects, to: &line)
				line.space()
				line.punctuation("{")
			}
			writer.indented { writer in
				StatementRenderer.render(getter.body.statements, to: &writer)
			}
			writer.writeLine("}")
		}
	}

	private static func render(_ setter: PropertyAccessorDescriptor.Setter, to writer: inout CodeWriter) {
		writer.indented { writer in
			writer.writeLine { line in
				renderAccessorName("set", parameterName: setter.parameterName, to: &line)
				line.space()
				line.punctuation("{")
			}
			writer.indented { writer in
				StatementRenderer.render(setter.body.statements, to: &writer)
			}
			writer.writeLine("}")
		}
	}

	private static func render(_ observers: [PropertyAccessorDescriptor.Observer], to writer: inout CodeWriter) {
		writer.indented { writer in
			for observer in observers {
				writer.writeLine { line in
					switch observer.kind {
					case let .willSet(parameterName):
						renderAccessorName("willSet", parameterName: parameterName, to: &line)
					case let .didSet(parameterName):
						renderAccessorName("didSet", parameterName: parameterName, to: &line)
					}
					line.space()
					line.punctuation("{")
				}
				writer.indented { writer in
					StatementRenderer.render(observer.body.statements, to: &writer)
				}
				writer.writeLine("}")
			}
		}
	}

	private static func renderAccessorName(
		_ name: String,
		parameterName: String?,
		to line: inout LineWriter,
	) {
		line.token(name, separateFromNextToken: parameterName == nil)
		if let parameterName {
			line.punctuation("(")
			line.token(SwiftIdentifier.sanitized(parameterName))
			line.punctuation(")")
		}
	}

	private static func render(_ effects: EffectSpecifiers<ThrowingSpecifier>, to line: inout LineWriter) {
		guard effects.isAsync || effects.throwingSpecifier != nil else { return }
		if effects.isAsync {
			line.token("async")
		}
		if let throwingSpecifier = effects.throwingSpecifier {
			line.token(CodeRenderingSupport.renderedThrowingSpecifier(throwingSpecifier))
		}
	}
}

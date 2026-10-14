//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ParametersListRenderer {
	static func render(_ parametersList: ParametersList, to writer: inout CodeWriter) {
		writer.writeLine { line in
			render(parametersList, into: &line)
		}
	}

	static func render(_ parametersList: ParametersList, into line: inout LineWriter) {
		line.punctuation("(")
		for (index, parameter) in parametersList.parameters.enumerated() {
			render(parameter, into: &line)
			if index < parametersList.parameters.endIndex - 1 {
				line.punctuation(",")
				line.space()
			}
		}
		line.punctuation(")")
	}

	private static func render(_ parameter: ParametersList.Parameter, into line: inout LineWriter) {
		for attribute in parameter.attributes {
			AttributeRenderer.render(attribute, to: &line)
		}
		if let label = parameter.label, label != parameter.identifier {
			line.token(SwiftIdentifier.sanitized(label))
		}
		line.token(SwiftIdentifier.sanitized(parameter.identifier))
		line.punctuation(":")
		line.space()
		if parameter.isInout {
			line.token("inout")
		}
		line.token(CodeRenderingSupport.renderedType(parameter.type))
		if let defaultValue = parameter.defaultValue {
			line.space()
			line.punctuation("=")
			line.space()
			line.token(CodeRenderingSupport.renderedExpression(defaultValue))
		}
	}
}

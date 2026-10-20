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
		line.punctuation(.leftParen)
		for (index, parameter) in parametersList.parameters.enumerated() {
			render(parameter, into: &line)
			if index < parametersList.parameters.endIndex - 1 {
				line.punctuation(.comma)
			}
		}
		line.punctuation(.rightParen)
	}

	private static func render(_ parameter: ParametersList.Parameter, into line: inout LineWriter) {
		for attribute in parameter.attributes {
			AttributeRenderer.render(attribute, to: &line)
		}
		if let label = parameter.label, label != parameter.identifier {
			line.token(SwiftIdentifier.sanitized(label, position: .argumentLabel))
		}
		line.token(SwiftIdentifier.sanitized(parameter.identifier))
		line.punctuation(.colon)
		if parameter.isInout {
			line.token("inout")
		}
		line.token(CodeRenderingSupport.renderedType(parameter.type))
		if let defaultValue = parameter.defaultValue {
			line.punctuation(.equal)
			line.token(ExpressionRenderer.renderedExpression(defaultValue))
		}
	}
}

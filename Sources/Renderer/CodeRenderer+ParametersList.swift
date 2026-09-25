//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderParametersList(_ parametersList: ParametersList) {
		renderParametersList(parametersList, to: &writer)
	}

	func renderParametersList(_ parametersList: ParametersList, to writer: inout CodeFileWriter) {
		writer.writeLine { line in
			renderParametersList(parametersList, into: &line)
		}
	}

	func renderParametersList(_ parametersList: ParametersList, into line: inout LineWriter) {
		line.punctuation("(")
		for (index, param) in parametersList.parameters.enumerated() {
			renderParameter(param, into: &line)
			if index < parametersList.parameters.endIndex - 1 {
				line.punctuation(",")
				line.space()
			}
		}
		line.punctuation(")")
	}

	func renderParameter(_ parameter: ParametersList.Parameter, into writer: inout LineWriter) {
		if let label = parameter.label, label != parameter.identifier {
			writer.token(label)
		}
		writer.token(parameter.identifier)
		writer.punctuation(":")
		writer.space()
		writer.token(renderedType(parameter.type))
		if let defaultValue = parameter.defaultValue {
			writer.space()
			writer.punctuation("=")
			writer.space()
			writer.token(renderedExpression(defaultValue))
		}
	}
}

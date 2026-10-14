//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum EnumRenderer {
	static func render(_ descriptor: AnyEnumDescriptor, to writer: inout CodeWriter) {
		CodeRenderingSupport.renderTypeSignature(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			attributes: descriptor.attributes,
			typeKeyword: "enum",
			identifier: descriptor.identifier,
			genericParameters: descriptor.genericParameters,
			genericRequirements: descriptor.genericRequirements,
			conformances: descriptor.conformances,
			to: &writer
		)

		if !descriptor.cases.isEmpty {
			writer.indented { writer in
				for caseDescriptor in descriptor.cases {
					render(caseDescriptor, to: &writer)
				}
			}

			if !descriptor.members.isEmpty {
				writer.writeNewLine()
			}
		}

		writer.indented { writer in
			TypeMemberRenderer.render(descriptor.members, to: &writer)
		}
		writer.writeLine("}")
	}

	private static func render(_ descriptor: AnyEnumCaseDescriptor, to writer: inout CodeWriter) {
		if let comment = descriptor.comment {
			writer.writeLine(comment.value, prefix: "/// ")
		}

		writer.writeLine { line in
			line.token("case")
			line.token(SwiftIdentifier.sanitized(descriptor.name))

			if !descriptor.associatedValues.isEmpty {
				line.punctuation("(")
				for (index, associatedValue) in descriptor.associatedValues.enumerated() {
					if let label = associatedValue.label {
						line.token(SwiftIdentifier.sanitized(label))
						line.punctuation(":")
						line.space()
					}
					line.token(CodeRenderingSupport.renderedType(associatedValue.type))

					if let defaultValue = associatedValue.defaultValue {
						line.space()
						line.punctuation("=")
						line.space()
						line.token(CodeRenderingSupport.renderedExpression(defaultValue))
					}

					if index < descriptor.associatedValues.count - 1 {
						line.punctuation(",")
						line.space()
					}
				}
				line.punctuation(")")
			}

			if let rawValue = descriptor.rawValue {
				line.space()
				line.punctuation("=")
				line.space()
				line.token(CodeRenderingSupport.renderedLiteral(rawValue))
			}
		}
	}
}

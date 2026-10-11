//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderEnum(_ descriptor: AnyEnumDescriptor) {
		renderEnum(descriptor, to: &writer)
	}

	func renderEnum(_ descriptor: PlainEnumDescriptor) {
		renderEnum(descriptor.descriptor, to: &writer)
	}

	func renderEnum(_ descriptor: RawValueEnumDescriptor<some RawValueEnumValueType>) {
		renderEnum(descriptor.descriptor, to: &writer)
	}

	func renderEnum(_ descriptor: AssociatedValueEnumDescriptor) {
		renderEnum(descriptor.descriptor, to: &writer)
	}

	func renderEnum(_ descriptor: AnyEnumDescriptor, to writer: inout CodeFileWriter) {
		renderTypeSignature(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			typeKeyword: "enum",
			identifier: descriptor.identifier,
			genericTypes: descriptor.genericTypes,
			conformances: descriptor.conformances,
			to: &writer
		)

		if !descriptor.cases.isEmpty {
			writer.indented { writer in
				for caseDescriptor in descriptor.cases {
					renderEnumCase(caseDescriptor, to: &writer)
				}
			}

			if !descriptor.members.isEmpty {
				writer.writeNewLine()
			}
		}

		renderTypeMembers(descriptor.members, to: &writer)

		writer.writeLine("}")
	}

	// MARK: - Enum case rendering

	func renderEnumCase(_ descriptor: AnyEnumCaseDescriptor, to writer: inout CodeFileWriter) {
		if let comment = descriptor.comment {
			writer.writeLine(comment.value, prefix: "/// ")
		}

		writer.writeLine { line in
			line.token("case")

			line.token(descriptor.name)

			if !descriptor.associatedValues.isEmpty {
				line.punctuation("(")
				for (index, associatedValue) in descriptor.associatedValues.enumerated() {
					if let label = associatedValue.label {
						line.token(label)
						line.punctuation(":")
						line.space()
					}
					line.token(renderedType(associatedValue.type))

					if let defaultValue = associatedValue.defaultValue {
						line.space()
						line.punctuation("=")
						line.space()
						line.token(renderedExpression(defaultValue))
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
				line.token(renderedLiteral(rawValue))
			}
		}
	}
}

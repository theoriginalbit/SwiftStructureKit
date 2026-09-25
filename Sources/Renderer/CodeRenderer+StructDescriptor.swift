//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderStruct(_ structDescriptor: StructDescriptor) {
		renderStruct(structDescriptor, to: &writer)
	}

	func renderStruct(_ structDescriptor: StructDescriptor, to writer: inout CodeFileWriter) {
		if let comment = structDescriptor.comment {
			writer.writeLine(comment.value, prefix: "/// ")
		}

		writer.writeLine { line in
			if let accessModifier = structDescriptor.accessModifier {
				line.token(renderedAccessModifier(accessModifier))
			}

			line.token("struct")

			line.token(structDescriptor.identifier)

			if !structDescriptor.genericTypes.isEmpty {
				line.punctuation("<")
				for (index, genericType) in structDescriptor.genericTypes.enumerated() {
					line.token(renderedType(genericType))
					if index < structDescriptor.genericTypes.count - 1 {
						line.punctuation(",")
						line.space()
					}
				}
				line.punctuation(">")
			}

			if !structDescriptor.conformances.isEmpty {
				line.punctuation(":")
				line.space()
				for (index, conformance) in structDescriptor.conformances.enumerated() {
					line.token(renderedType(conformance))
					if index < structDescriptor.conformances.count - 1 {
						line.punctuation(",")
						line.space()
					}
				}
			}

			line.space()
			line.punctuation("{")
		}

		if !structDescriptor.members.isEmpty {
			writer.indented { writer in
				for (index, member) in structDescriptor.members.enumerated() {
					renderTypeMember(member, to: &writer)
					if index < structDescriptor.members.count - 1 {
						writer.writeNewLine()
					}
				}
			}
		}

		writer.writeLine("}")
	}
}

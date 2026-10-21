//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum EnumRenderer {
	static func render(_ descriptor: AnyEnumDescriptor, to writer: inout CodeWriter) {
		CodeRenderingSupport.renderTypeDeclaration(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			attributes: descriptor.attributes,
			typeKeyword: "enum",
			identifier: descriptor.identifier,
			genericParameters: descriptor.genericParameters,
			genericRequirements: descriptor.genericRequirements,
			conformances: descriptor.conformances,
			to: &writer
		) { writer in
			if !descriptor.cases.isEmpty {
				var previousHadComment = false
				for (index, caseDescriptor) in descriptor.cases.enumerated() {
					// Separate a documented case from its neighbours so the comment visibly
					// belongs to one case, but never open the enum body with a blank line.
					let hasComment = caseDescriptor.comment != nil
					if index > 0, hasComment || previousHadComment {
						writer.writeBlankLine()
					}
					render(caseDescriptor, to: &writer)
					previousHadComment = hasComment
				}

				if !descriptor.members.isEmpty {
					writer.writeBlankLine()
				}
			}

			DeclarationDescriptorRenderer.render(descriptor.members, to: &writer)
		}
	}

	private static func render(_ descriptor: AnyEnumCaseDescriptor, to writer: inout CodeWriter) {
		CommentRenderer.renderDocComment(descriptor.comment, to: &writer)

		writer.writeLine { line in
			line.token("case")
			line.token(SwiftIdentifier.sanitized(descriptor.name))

			if !descriptor.associatedValues.isEmpty {
				line.punctuation(.leftParen)
				for (index, associatedValue) in descriptor.associatedValues.enumerated() {
					if let label = associatedValue.label {
						line.token(SwiftIdentifier.sanitized(label, position: .argumentLabel))
						line.punctuation(.colon)
					}
					line.token(CodeRenderingSupport.renderedType(associatedValue.type))

					if let defaultValue = associatedValue.defaultValue {
						line.punctuation(.equal)
						ExpressionRenderer.render(defaultValue, to: &line)
					}

					if index < descriptor.associatedValues.count - 1 {
						line.punctuation(.comma)
					}
				}
				line.punctuation(.rightParen)
			}

			if let rawValue = descriptor.rawValue {
				line.punctuation(.equal)
				line.token(CodeRenderingSupport.renderedLiteral(rawValue))
			}
		}
	}
}

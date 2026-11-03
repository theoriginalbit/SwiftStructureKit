//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ClassRenderer {
	static func render(_ descriptor: ClassDescriptor, to writer: inout CodeWriter) {
		// The grammar of classes is different from other types, it would
		// make no sense to modify renderTypeDeclaration for classes. Nearly
		// duplicate implementation makes most sense.
		CommentRenderer.renderDocComment(descriptor.comment, to: &writer)
		AttributeRenderer.render(descriptor.attributes, to: &writer)

		writer.writeLine { line in
			if let accessModifier = descriptor.accessModifier {
				line.token(renderedAccessModifier(accessModifier))
			}
			if descriptor.isFinal {
				line.token("final")
			}
			line.token("class")
			line.token(CodeRenderingSupport.renderedType(
				.identifier([descriptor.identifier]) // pass as components to avoid splitting by '.' and let the sanitizer replace
			))
			CodeRenderingSupport.renderGenericSignature(descriptor.genericParameters, to: &line)

			if !descriptor.conformances.isEmpty {
				line.punctuation(.colon)
				let conformances = descriptor.conformances.removingDuplicates()
				line.token(CodeRenderingSupport.renderedTypesList(conformances))
			}

			CodeRenderingSupport.renderGenericRequirements(descriptor.genericRequirements, to: &line)
			line.block { writer in
				DeclarationDescriptorRenderer.render(descriptor.members, to: &writer)
			}
		}
	}

	static func renderedAccessModifier(_ accessModifier: ClassAccessModifierDescriptor) -> String {
		switch accessModifier {
		case .open: "open"
		case let .base(descriptor): CodeRenderingSupport.renderedAccessModifier(descriptor)
		}
	}
}


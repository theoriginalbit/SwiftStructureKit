//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum TypealiasRenderer {
	static func render(_ descriptor: TypealiasDescriptor, to writer: inout CodeWriter) {
		CommentRenderer.renderDocComment(descriptor.comment, to: &writer)
		AttributeRenderer.render(descriptor.attributes, to: &writer)
		writer.writeLine { line in
			if let accessModifier = descriptor.accessModifier {
				line.token(CodeRenderingSupport.renderedAccessModifier(accessModifier))
			}
			line.token("typealias")
			line.token(SwiftIdentifier.sanitized(descriptor.name))
			line.token("=")
			line.token(CodeRenderingSupport.renderedComposition(descriptor.assignedType))
		}
	}
}

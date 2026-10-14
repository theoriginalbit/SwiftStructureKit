//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum TypealiasRenderer {
	static func render(_ descriptor: TypealiasDescriptor, to writer: inout CodeWriter) {
		AttributeRenderer.render(descriptor.attributes, to: &writer)
		writer.writeLine { line in
			if let accessModifier = descriptor.accessModifier {
				line.token(CodeRenderingSupport.renderedAccessModifier(accessModifier))
			}
			line.token("typealias")
			line.token(CodeRenderingSupport.renderedType(descriptor.identifier))
			line.token("=")
			line.token(CodeRenderingSupport.renderedComposedTypes(descriptor.assignedType))
		}
	}
}

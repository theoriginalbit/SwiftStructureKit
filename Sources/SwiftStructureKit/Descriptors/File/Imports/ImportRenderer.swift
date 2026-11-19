//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ImportRenderer {
	static func render(_ descriptor: ImportDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			var seenAttributes: Set<AttributeDescriptor> = []
			for attribute in descriptor.attributes {
				if seenAttributes.contains(attribute) { continue }
				seenAttributes.insert(attribute)
				AttributeRenderer.render(attribute, to: &line)
			}

			if let accessModifier = descriptor.accessModifier {
				line.token(CodeRenderingSupport.renderedAccessModifier(accessModifier))
			}

			line.token("import")

			switch descriptor.kind {
			case .none:
				break
			case .class:
				line.token("class")
			case .enum:
				line.token("enum")
			case .function:
				line.token("func")
			case .protocol:
				line.token("protocol")
			case .struct:
				line.token("struct")
			case .typealias:
				line.token("typealias")
			case .var:
				line.token("var")
			case .let:
				line.token("let")
			}

			line.token(descriptor.moduleName)
			if let submodule = descriptor.submodule {
				line.punctuation(.period)
				line.token(submodule)
			}
		}
	}
}

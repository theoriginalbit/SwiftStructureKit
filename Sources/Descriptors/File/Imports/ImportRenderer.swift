//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ImportRenderer {
	static func render(_ descriptor: ImportDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			// We can only de-duplicate once the attribute has been rendered since
			// AttributeDescriptor offers .rawValue which could dupe a convenience
			// type. Performing de-dupe here also handles the scenario where a
			// consumer could have supplied .rawValue("A") and .rawValue("@A")
			// which would also have not been considered a duplicate.
			var seenAttributes: Set<String> = []
			for attribute in descriptor.attributes {
				let rendered = AttributeRenderer.rendered(attribute)
				if seenAttributes.contains(rendered) { continue }
				seenAttributes.insert(rendered)
				line.token(rendered)
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

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum SwiftFileRenderer {
	static func render(_ descriptor: SwiftFile, to writer: inout CodeWriter) {
		// Each present section is separated from the previous one by a single blank line.
		// Nothing is written before the first section or after the last, so a headerless
		// file does not start with a blank line and a file without declarations does not
		// end with one.
		var hasPrecedingSection = false
		func beginSection() {
			if hasPrecedingSection {
				writer.writeBlankLine()
			}
			hasPrecedingSection = true
		}

		if let headerComment = descriptor.headerComment {
			beginSection()
			writer.writeLine("//")
			writer.writeLine(headerComment.value, prefix: "// ")
			writer.writeLine("//")
		}

		if !descriptor.imports.isEmpty {
			beginSection()
			for importDescriptor in descriptor.imports {
				render(importDescriptor, to: &writer)
			}
		}

		if !descriptor.declarations.isEmpty {
			beginSection()
			TypeMemberRenderer.render(descriptor.declarations, to: &writer)
		}
	}

	private static func render(_ descriptor: ImportDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			for attribute in descriptor.attributes {
				line.token(attribute.hasPrefix("@") ? attribute : "@\(attribute)")
			}

			if let accessModifier = descriptor.accessModifier {
				line.token(CodeRenderingSupport.renderedAccessModifier(accessModifier))
			}

			line.token("import")

			if let kind = descriptor.kind {
				line.token(kind.rawValue)
			}

			line.token(descriptor.moduleName)
			if let submodule = descriptor.submodule {
				line.punctuation(.period)
				line.token(submodule)
			}
		}
	}
}

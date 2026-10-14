//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum SwiftFileRenderer {
	static func render(_ descriptor: SwiftFile, to writer: inout CodeWriter) {
		if let headerComment = descriptor.headerComment {
			writer.writeLine("//")
			writer.writeLine(headerComment.value, prefix: "// ")
			writer.writeLine("//")
		}

		guard !descriptor.imports.isEmpty || !descriptor.declarations.isEmpty else {
			// early exit to avoid writing newlines when there is no content
			// result will be a file with just a header, or a zero byte file
			return
		}

		writer.writeNewLine()

		for importDescriptor in descriptor.imports {
			render(importDescriptor, to: &writer)
		}

		if !descriptor.imports.isEmpty {
			// if there were imports add a new line
			writer.writeNewLine()
		}

		TypeMemberRenderer.render(descriptor.declarations, to: &writer)

		if !writer.isLastByteNewLine() {
			writer.writeNewLine()
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
				line.punctuation(".")
				line.token(submodule)
			}
		}
	}
}

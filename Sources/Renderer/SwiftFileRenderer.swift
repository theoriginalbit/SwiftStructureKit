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
			writer.writeSeparated(descriptor.declarations) { declaration, writer in
				render(declaration, to: &writer)
			}
		}
	}

	private static func render(_ descriptor: ImportDescriptor, to writer: inout CodeWriter) {
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

	private static func render(_ declaration: TopLevelDeclarationDescriptor, to writer: inout CodeWriter) {
		switch declaration {
		case let .member(descriptor):
			DeclarationDescriptorRenderer.render(descriptor, to: &writer)
		case let .extension(descriptor):
			ExtensionRenderer.render(descriptor, to: &writer)
		}
	}
}

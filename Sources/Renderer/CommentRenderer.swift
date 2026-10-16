//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum CommentRenderer {
	static func renderMarkComment(_ descriptor: MarkCommentDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			line.token("// MARK:")
			if descriptor.sectionBreak {
				line.token("-")
			}
			if let value = descriptor.value {
				line.token(value)
			}
		}
	}

	static func renderInlineComment(_ descriptor: InlineCommentDescriptor, to writer: inout CodeWriter) {
		writer.writeLine(descriptor.value, prefix: "// ")
	}

	static func renderDocComment(_ descriptor: DocCommentDescriptor?, to writer: inout CodeWriter) {
		guard let descriptor else { return }
		if descriptor.value.isEmpty {
			writer.writeLine("///")
		} else {
			writer.writeLine(descriptor.value, prefix: "/// ")
		}
	}
}

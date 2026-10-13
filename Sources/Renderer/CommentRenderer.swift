//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum CommentRenderer {
	static func renderMarkComment(_ descriptor: MarkCommentDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			line.token("// MARK:")
			if descriptor.sectionBreak {
				line.space()
				line.punctuation("-")
				line.space()
			}
			if let value = descriptor.value {
				line.token(value)
			}
		}
	}

	static func renderInlineComment(_ descriptor: InlineCommentDescriptor, to writer: inout CodeWriter) {
		writer.writeLine(descriptor.value, prefix: "// ")
	}
}

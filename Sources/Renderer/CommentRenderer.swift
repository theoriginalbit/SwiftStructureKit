//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum CommentRenderer {
	static func renderMarkComment(_ descriptor: MarkCommentDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			line.token("// MARK:")
			if descriptor.sectionBreak {
				line.punctuation(.minus)
			}
			if let value = descriptor.value, !value.isEmpty {
				// A MARK comment is only recognised by Xcode when it occupies a single line, so
				// any embedded newlines are escaped to avoid source issues
				line.token(escapingNewlines(in: value))
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

	private static func escapingNewlines(in value: String) -> String {
		guard value.contains(where: \.isNewline) else { return value }

		var result = ""
		result.reserveCapacity(value.utf8.count + 8)
		for character in value {
			if character.isNewline {
				result += "\\n"
			} else {
				result.append(character)
			}
		}
		return result
	}
}

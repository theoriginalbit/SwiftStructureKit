//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum FileRenderer {
	static func render(_ descriptor: FileDescriptor, to writer: inout CodeFileWriter) {
		if let headerComment = descriptor.headerComment {
			writer.writeLine(headerComment.value, prefix: "// ")
			if !descriptor.declarations.isEmpty {
				writer.writeNewLine()
			}
		}

		TypeMemberRenderer.render(descriptor.declarations, to: &writer)
	}
}

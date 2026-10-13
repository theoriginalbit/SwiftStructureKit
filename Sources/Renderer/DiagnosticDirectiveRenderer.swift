//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum DiagnosticDirectiveRenderer {
	static func render(_ descriptor: DiagnosticDirectiveDescriptor, to writer: inout CodeFileWriter) {
		writer.writeLine { line in
			line.punctuation("#")
			switch descriptor.kind {
			case .warning: line.token("warning", separateFromNextToken: false)
			case .error: line.token("error", separateFromNextToken: false)
			}
			line.punctuation("(")
			line.token(CodeRenderingSupport.renderedLiteral(.string(descriptor.message)))
			line.punctuation(")")
		}
	}
}

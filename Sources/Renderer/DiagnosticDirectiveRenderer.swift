//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum DiagnosticDirectiveRenderer {
	static func render(_ descriptor: DiagnosticDirectiveDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			line.punctuation(.Prefix.pound)
			switch descriptor.kind {
			case .warning: line.token("warning")
			case .error: line.token("error")
			}
			line.punctuation(.leftParen)
			line.token(CodeRenderingSupport.renderedLiteral(.string(descriptor.message)))
			line.punctuation(.rightParen)
		}
	}
}

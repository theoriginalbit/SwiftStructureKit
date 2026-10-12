//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderDiagnosticDirective(_ descriptor: DiagnosticDirectiveDescriptor) {
		renderDiagnosticDirective(descriptor, to: &writer)
	}

	func renderDiagnosticDirective(_ descriptor: DiagnosticDirectiveDescriptor, to writer: inout CodeFileWriter) {
		writer.writeLine { line in
			line.punctuation("#")
			switch descriptor.kind {
			case .warning: line.token("warning", separateFromNextToken: false)
			case .error: line.token("error", separateFromNextToken: false)
			}
			line.punctuation("(")
			line.token(renderedLiteral(.string(descriptor.message)))
			line.punctuation(")")
		}
	}
}

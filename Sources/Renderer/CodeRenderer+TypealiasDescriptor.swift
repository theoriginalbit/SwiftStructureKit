//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderTypealias(_ descriptor: TypealiasDescriptor, to writer: inout CodeFileWriter) {
		writer.writeLine { line in
			if let accessModifier = descriptor.accessModifier {
				line.token(renderedAccessModifier(accessModifier))
			}
			line.token("typealias")
			line.token(renderedType(descriptor.identifier))
			line.token("=")
			line.token(renderedType(descriptor.assignedType))
		}
	}
}

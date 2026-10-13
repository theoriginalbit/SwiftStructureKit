//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum TypeMemberRenderer {
	static func render(_ declarations: [TypeMemberDescriptor], to writer: inout CodeWriter) {
		guard !declarations.isEmpty else { return }
		for (index, declaration) in declarations.enumerated() {
			render(declaration, to: &writer)
			if index < declarations.count - 1 {
				writer.writeNewLine()
			}
		}
	}

	static func render(_ member: TypeMemberDescriptor, to writer: inout CodeWriter) {
		switch member {
		case let .enum(descriptor):
			EnumRenderer.render(descriptor, to: &writer)
		case let .function(descriptor):
			FunctionRenderer.render(descriptor, to: &writer)
		case let .mark(descriptor):
			CommentRenderer.renderMarkComment(descriptor, to: &writer)
		case let .property(descriptor):
			PropertyRenderer.render(descriptor, to: &writer)
		case let .protocol(descriptor):
			ProtocolRenderer.render(descriptor, to: &writer)
		case let .struct(descriptor):
			StructRenderer.render(descriptor, to: &writer)
		case let .typealias(descriptor):
			TypealiasRenderer.render(descriptor, to: &writer)
		}
	}
}

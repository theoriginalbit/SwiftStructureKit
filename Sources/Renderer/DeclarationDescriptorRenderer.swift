//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum DeclarationDescriptorRenderer {
	static func render(_ declarations: [DeclarationDescriptor], to writer: inout CodeWriter) {
		writer.writeSeparated(declarations, render(_:to:))
	}

	static func render(_ member: DeclarationDescriptor, to writer: inout CodeWriter) {
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

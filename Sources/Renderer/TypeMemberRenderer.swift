//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum TypeMemberRenderer {
	static func render(_ members: [TypeMemberDescriptor], to writer: inout CodeFileWriter) {
		guard !members.isEmpty else { return }
		writer.indented { writer in
			for (index, member) in members.enumerated() {
				render(member, to: &writer)
				if index < members.count - 1 {
					writer.writeNewLine()
				}
			}
		}
	}

	private static func render(_ member: TypeMemberDescriptor, to writer: inout CodeFileWriter) {
		switch member {
		case let .function(descriptor):
			FunctionRenderer.render(descriptor, to: &writer)
		case let .enum(descriptor):
			EnumRenderer.render(descriptor, to: &writer)
		case let .struct(descriptor):
			StructRenderer.render(descriptor, to: &writer)
		case let .protocol(descriptor):
			ProtocolRenderer.render(descriptor, to: &writer)
		case let .mark(descriptor):
			CodeRenderingSupport.renderMarkComment(descriptor, to: &writer)
		}
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderTypeMembers(_ members: [TypeMemberDescriptor], to writer: inout CodeFileWriter) {
		guard !members.isEmpty else { return }
		writer.indented { writer in
			for (index, member) in members.enumerated() {
				renderTypeMember(member, to: &writer)
				if index < members.count - 1 {
					writer.writeNewLine()
				}
			}
		}
	}

	func renderTypeMember(_ member: TypeMemberDescriptor, to writer: inout CodeFileWriter) {
		switch member {
		case let .function(descriptor):
			renderFunction(descriptor, to: &writer)
		case let .enum(descriptor):
			renderEnum(descriptor, to: &writer)
		case let .struct(descriptor):
			renderStruct(descriptor, to: &writer)
		case let .mark(descriptor):
			renderMarkComment(descriptor, to: &writer)
		}
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum StructRenderer {
	static func render(_ descriptor: StructDescriptor, to writer: inout CodeFileWriter) {
		CodeRenderingSupport.renderTypeSignature(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			typeKeyword: "struct",
			identifier: descriptor.identifier,
			genericTypes: descriptor.genericTypes,
			conformances: descriptor.conformances,
			to: &writer
		)
		TypeMemberRenderer.render(descriptor.members, to: &writer)
		writer.writeLine("}")
	}
}

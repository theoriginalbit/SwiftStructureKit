//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum StructRenderer {
	static func render(_ descriptor: StructDescriptor, to writer: inout CodeWriter) {
		CodeRenderingSupport.renderTypeSignature(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			attributes: descriptor.attributes,
			typeKeyword: "struct",
			identifier: descriptor.identifier,
			genericParameters: descriptor.genericParameters,
			genericRequirements: descriptor.genericRequirements,
			conformances: descriptor.conformances,
			to: &writer
		)
		writer.indented { writer in
			TypeMemberRenderer.render(descriptor.members, to: &writer)
		}
		writer.writeLine("}")
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ExtensionRenderer {
	static func render(_ descriptor: ExtensionDescriptor, to writer: inout CodeWriter) {
		CodeRenderingSupport.renderTypeDeclaration(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			attributes: descriptor.attributes,
			typeKeyword: "extension",
			identifier: descriptor.extendedType,
			genericParameters: [],
			genericRequirements: descriptor.genericRequirements,
			conformances: descriptor.conformances,
			to: &writer) { writer in
				DeclarationDescriptorRenderer.render(descriptor.members, to: &writer)
			}
	}
}

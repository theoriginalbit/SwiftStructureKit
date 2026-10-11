//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderStruct(_ structDescriptor: StructDescriptor) {
		renderStruct(structDescriptor, to: &writer)
	}

	func renderStruct(_ descriptor: StructDescriptor, to writer: inout CodeFileWriter) {
		renderTypeSignature(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			typeKeyword: "struct",
			identifier: descriptor.identifier,
			genericTypes: descriptor.genericTypes,
			conformances: descriptor.conformances,
			to: &writer
		)
		renderTypeMembers(descriptor.members, to: &writer)

		writer.writeLine("}")
	}
}

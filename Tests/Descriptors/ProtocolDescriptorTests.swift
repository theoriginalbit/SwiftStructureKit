//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration)) struct ProtocolDescriptorTests {
	@Test("Add primary associated types after explicit generic types")
	func addPrimaryAssociatedTypesToGenericParameters() {
		let descriptor = ProtocolDescriptor(
			"Collection",
			genericParameters: ["Index", "Element"],
		) {
			ProtocolAssociatedtypeDescriptor(
				"Element",
				conformsTo: .equatable,
				isPrimary: true,
			)
			ProtocolAssociatedtypeDescriptor(
				"SubSequence",
				defaultType: .identifier("Self"),
				isPrimary: true,
			)
			ProtocolAssociatedtypeDescriptor("Iterator")
		}

		// Validate primary associated types (PAT) are added to generic parameter list
		// NOTE: duplication will still exist at this stage and are removed at render
		#expect(Array(descriptor.genericParameters) == [
			GenericParameterDescriptor("Index"),
			GenericParameterDescriptor("Element"),
			GenericParameterDescriptor("Element"),
			GenericParameterDescriptor("SubSequence"),
		])
		// Validate PAT are still members
		#expect(descriptor.members.count == 3)
	}
}

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
				sameTypeAs: .identifier("Self"),
				isPrimary: true,
			)
			ProtocolAssociatedtypeDescriptor("Iterator")
		}

		#expect(Array(descriptor.genericParameters) == [
			GenericParameterDescriptor("Index"),
			GenericParameterDescriptor("Element"),
			GenericParameterDescriptor("SubSequence"),
		])
		#expect(descriptor.members.count == 3)
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration)) struct ProtocolDescriptorTests {
	@Test("Add primary associated types after explicit generic types")
	func addPrimaryAssociatedTypesToGenericTypes() {
		let descriptor = ProtocolDescriptor(
			"Collection",
			genericTypes: [.identifier("Index"), .identifier("Element")],
		) {
			ProtocolAssociatedtypeDescriptor(
				.identifier("Element"),
				conformsTo: .equatable,
				isPrimary: true,
			)
			ProtocolAssociatedtypeDescriptor(
				.identifier("SubSequence"),
				sameTypeAs: .identifier("Self"),
				isPrimary: true,
			)
			ProtocolAssociatedtypeDescriptor(.identifier("Iterator"))
		}

		#expect(Array(descriptor.genericTypes) == [
			.identifier("Index"),
			.identifier("Element"),
			.identifier("SubSequence"),
		])
		#expect(descriptor.members.count == 3)
	}
}

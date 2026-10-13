//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import OrderedCollections
import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration)) struct TypealiasDescriptorTests {
	@Test("Create typealias descriptor with one assigned type")
	func createTypealiasWithSingleAssignedType() {
		let descriptor = TypealiasDescriptor(
			.identifier("StringAlias"),
			accessModifier: .public,
			assignedType: .string,
		)

		#expect(descriptor.identifier == .identifier("StringAlias"))
		#expect(descriptor.accessModifier == .public)
		#expect(descriptor.assignedType == [.string])
	}

	@Test("Create typealias descriptor with composed assigned types")
	func createTypealiasWithComposedAssignedTypes() {
		let assignedTypes: OrderedSet<TypeReference> = [.sendable, .equatable]
		let descriptor = TypealiasDescriptor(
			.identifier("Value"),
			assignedTypes: assignedTypes,
		)

		#expect(descriptor.identifier == .identifier("Value"))
		#expect(descriptor.accessModifier == nil)
		#expect(descriptor.assignedType == assignedTypes)
	}
}

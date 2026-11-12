//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration)) struct TypealiasDescriptorTests {
	@Test("Create typealias descriptor with one assigned type")
	func createTypealiasWithSingleAssignedType() {
		let descriptor = TypealiasDescriptor(
			"StringAlias",
			accessModifier: .public,
			assignedType: .string,
		)

		#expect(descriptor.name == "StringAlias")
		#expect(descriptor.accessModifier == .public)
		#expect(descriptor.assignedType.types == [.string])
	}

	@Test("Create typealias descriptor with composed assigned types")
	func createTypealiasWithComposedAssignedTypes() {
		let assignedTypes: [TypeReference] = [.sendable, .equatable]
		let descriptor = TypealiasDescriptor(
			"Value",
			assignedTypes: assignedTypes,
		)

		#expect(descriptor.name == "Value")
		#expect(descriptor.accessModifier == nil)
		#expect(descriptor.assignedType.types == assignedTypes)
	}

	@Test("Create typealias descriptor with generic type")
	func createTypealiasWithGenericParameters() {
		let genericParameters: [GenericParameterDescriptor] = [
			GenericParameterDescriptor("T", constraint: TypeComposition("Equatable"))
		]
		let assignedTypes: [TypeReference] = [
			TypeReference.generic("ArrayBuilder", arguments: [
				.identifier("T"),
			]),
		]
		let descriptor = TypealiasDescriptor(
			"Value",
			genericParameters: genericParameters,
			assignedTypes: assignedTypes,
		)

		#expect(descriptor.name == "Value")
		#expect(descriptor.accessModifier == nil)
		#expect(descriptor.genericParameters == genericParameters)
		#expect(descriptor.assignedType.types == assignedTypes)
	}
}

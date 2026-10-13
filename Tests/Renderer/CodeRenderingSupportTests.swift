//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct CodeRenderingSupportTests {
	@Test("Render structured type references")
	func renderTypeReferences() {
		let types: [TypeReference] = [
			.string,
			.array(.identifier("Element")),
			.dictionary(key: .string, value: .optional(.int)),
			.any(.sendable),
			.some(.identifier("Sequence")),
			.tuple {
				TupleElementDescriptor(label: "name", type: .string)
				TupleElementDescriptor(type: .int)
			},
			.closure(parameters: [.int, .string], returns: .bool),
			.genericParameter("Element", constraints: [.equatable, .sendable]),
		]
		let output = types
			.map(CodeRenderingSupport.renderedType(_:))
			.joined(separator: "\n") + "\n"

		let expected = """
			String
			Array<Element>
			Dictionary<String, Optional<Int>>
			any Sendable
			some Sequence
			(name: String, Int)
			(Int, String) -> Bool
			Element: Equatable & Sendable
			
			"""

		#expect(output == expected)
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct CodeRenderingSupportTests {
	@Test("Sanitize Swift identifiers defensively", arguments: [
		("$nake…", "$nake_x2026_"),
		("9-$patch", "_9_hyphen__dollar_patch"),
		("class", "`class`"),
		("", "_empty"),
	])
	func sanitizeSwiftIdentifiers(input: String, expected: String) {
		#expect(SwiftIdentifier.sanitized(input) == expected)
	}

	@Test("Preserves underscore")
	func preservesUnderscore() {
		#expect(SwiftIdentifier.sanitized("_") == "_")
	}

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

	@Test("Sanitize identifiers in rendered types and tuple labels")
	func sanitizeRenderedTypes() {
		let output = CodeRenderingSupport.renderedTypesList([
			.identifier("$Response"),
			.genericParameter("1Element", constraints: [.identifier("class")]),
			.tuple([TupleElementDescriptor(label: "try", type: .identifier("Value"))]),
		])

		#expect(output == "$Response, _1Element: `class`, (`try`: Value)")
	}
}

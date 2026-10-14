//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit
import OrderedCollections

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

	@Test("Render structured type references", arguments: [
		(.string, "String"),
		(.array(.identifier("Element")), "Array<Element>"),
		(.dictionary(key: .string, value: .optional(.int)), "Dictionary<String, Optional<Int>>"),
		(.any(.sendable), "any Sendable"),
		(.some(.identifier("Sequence")), "some Sequence"),
		(.tuple {
			TupleElementDescriptor(label: "name", type: .string)
			TupleElementDescriptor(type: .int)
		}, "(name: String, Int)"),
		(.closure(parameters: [.int, .string], returns: .bool), "(Int, String) -> Bool"),
		(.identifier("Foo.Bar"), "Foo.Bar"),
		(.generic("F", arguments: [.int, .identifier("Int.Stride")]), "F<Int, Int.Stride>"),
	] as [(TypeReference, String)])
	func renderTypeReferences(input: TypeReference, expected: String) {
		let output = CodeRenderingSupport.renderedType(input)
		#expect(output == expected)
	}

	@Test("Sanitize identifiers in rendered types and tuple labels")
	func sanitizeRenderedTypes() {
		let output = CodeRenderingSupport.renderedTypesList([
			.identifier("$Response"),
			.tuple([TupleElementDescriptor(label: "try", type: .identifier("Value"))]),
		])

		#expect(output == "$Response, (`try`: Value)")
	}

	@Test("Render generic parameters and where constraints separately")
	func renderGenericParametersAndConstraints() {
		let parameter = GenericParameterDescriptor(
			"Element",
			constraint: TypeComposition([.equatable, .sendable])
		)
		let requirement = TypeConstraintDescriptor(
			"T",
			conformsTo: .equatable
		)

		#expect(CodeRenderingSupport.renderedGenericParameter(parameter) == "Element: Equatable & Sendable")
		#expect(CodeRenderingSupport.renderedConstraint(requirement) == "T: Equatable")
	}
}

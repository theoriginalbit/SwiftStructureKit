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
		("`typealias`", "`typealias`"),
		("``", "``"),
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

	@Test("Render closure attributes and effects", arguments: [
		([], EffectSpecifiers<ThrowingSpecifier>.none, "(Int) -> Void"),
		([.init("Sendable")], EffectSpecifiers<ThrowingSpecifier>.none, "@Sendable (Int) -> Void"),
		([.mainActor, .init("Sendable")], EffectSpecifiers<ThrowingSpecifier>.none, "@MainActor @Sendable (Int) -> Void"),
		([.init("Sendable")], .async, "@Sendable (Int) async -> Void"),
		([.init("Sendable")], .throws, "@Sendable (Int) throws -> Void"),
		([.init("Sendable")], .throws(.identifier("ReadError")), "@Sendable (Int) throws(ReadError) -> Void"),
		([.init("Sendable")], EffectSpecifiers<ThrowingSpecifier>(isAsync: true, throwingSpecifier: .throws), "@Sendable (Int) async throws -> Void"),
	] as [(OrderedSet<AttributeDescriptor>, EffectSpecifiers<ThrowingSpecifier>, String)])
	func renderClosure(
		attributes: OrderedSet<AttributeDescriptor>,
		effects: EffectSpecifiers<ThrowingSpecifier>,
		expected: String
	) {
		let closure = TypeReference.closure(
			parameters: [.int],
			returns: .identifier("Void"),
			attributes: attributes,
			effects: effects
		)

		#expect(CodeRenderingSupport.renderedType(closure) == expected)
	}
}

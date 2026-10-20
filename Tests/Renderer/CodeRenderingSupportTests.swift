//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct CodeRenderingSupportTests {
	@Test("Render every access modifier", arguments: [
		(.public, "public"),
		(.package, "package"),
		(.internal, "internal"),
		(.fileprivate, "fileprivate"),
		(.private, "private"),
	] as [(AccessModifierDescriptor, String)])
	func renderAccessModifiers(modifier: AccessModifierDescriptor, expected: String) {
		#expect(CodeRenderingSupport.renderedAccessModifier(modifier) == expected)
	}

	@Test("Render every attribute kind", arguments: [
		(.rawValue("Observable"), "@Observable"),
		(.rawValue("@Observable"), "@Observable"),
		(.resultBuilder("ViewBuilder"), "@ViewBuilder"),
		(.available("iOS 17, *"), "@available(iOS 17, *)"),
		(.objc(), "@objc"),
		(.objc(name: "SKValue"), "@objc(SKValue)"),
		(.mainActor, "@MainActor"),
		(.frozen, "@frozen"),
		(.inlinable, "@inlinable"),
		(.discardableResult, "@discardableResult"),
		(.disfavoredOverload, "@_disfavoredOverload"),
	] as [(AttributeDescriptor, String)])
	func renderAttributes(attribute: AttributeDescriptor, expected: String) {
		#expect(AttributeRenderer.rendered(attribute) == expected)
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
		expectRendered(output, equals: expected)
	}

	@Test("Sanitize identifiers in rendered types and tuple labels")
	func sanitizeRenderedTypes() {
		let output = CodeRenderingSupport.renderedTypesList([
			.identifier("$Response"),
			.tuple([TupleElementDescriptor(label: "try", type: .identifier("Value"))]),
		])

		expectRendered(output, equals: "_dollar_Response, (try: Value)")
	}

	@Test("Qualified identifiers only escape the leading component", arguments: [
		((TypeIdentifier("Color.default"), "Color.default")),
		(TypeIdentifier("self.init"), "self.init"),
		(TypeIdentifier("default.value"), "`default`.value"),
		(TypeIdentifier("self.$binding"), "self.$binding"),
		(TypeIdentifier("$binding.wrappedValue"), "$binding.wrappedValue"),
	] as [(TypeIdentifier, String)])
	func qualifiedIdentifierEscaping(identifier: TypeIdentifier, expected: String) {
		#expect(CodeRenderingSupport.renderedIdentifier(identifier) == expected)
	}

	@Test("Type names never carry a $ prefix even where expressions may")
	func typeIdentifiersRejectDollarPrefix() {
		#expect(CodeRenderingSupport.renderedIdentifier(TypeIdentifier("$Response"), as: .type) == "_dollar_Response")
		#expect(CodeRenderingSupport.renderedIdentifier(TypeIdentifier("Outer.$Inner"), as: .type) == "Outer._dollar_Inner")
		#expect(CodeRenderingSupport.renderedType(.generic("$Box", arguments: [.int])) == "_dollar_Box<Int>")
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
	] as [([AttributeDescriptor], EffectSpecifiers<ThrowingSpecifier>, String)])
	func renderClosure(
		attributes: [AttributeDescriptor],
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

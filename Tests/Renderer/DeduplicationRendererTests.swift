//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct DeduplicationRendererTests {
	// MARK: - Conformances De-duplication

	@Test("De-duplicate conformances when rendering struct")
	func deduplicateStructConformances() {
		let descriptor = StructDescriptor(
			"Widget",
			conformances: [
				.sendable,
				.equatable,
				.sendable, // should be removed
				.identifier("CustomStringConvertible"),
				.equatable, // should be removed
			]
		) {}
		let output = RenderTest.render { writer in
			StructRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			struct Widget: Sendable, Equatable, CustomStringConvertible {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("De-duplicate conformances when rendering plain enum")
	func deduplicatePlainEnumConformances() {
		let descriptor = PlainEnumDescriptor(
			"Status",
			conformances: [
				.sendable,
				.equatable,
				.sendable, // should be removed
			]
		)
		let output = RenderTest.render { writer in
			EnumRenderer.render(descriptor.descriptor, to: &writer)
		}
		let expected = """
			enum Status: Sendable, Equatable {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("De-duplicate conformances when rendering raw value enum")
	func deduplicateRawValueEnumConformances() {
		let descriptor = RawValueEnumDescriptor<String>(
			"State",
			conformances: [
				.sendable,
				.string, // should be removed here but be in first position since it is the raw type
				.sendable, // should be removed
				.string, // should be removed here but be in first position since it is the raw type
			]
		) {}
		let output = RenderTest.render { writer in
			EnumRenderer.render(descriptor.descriptor, to: &writer)
		}
		let expected = """
			enum State: String, Sendable {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("De-duplicate conformances when rendering protocol")
	func deduplicateProtocolConformances() {
		let descriptor = ProtocolDescriptor(
			"MyProtocol",
			conformances: [
				.sendable,
				.equatable,
				.sendable, // should be removed
			]
		) {}
		let output = RenderTest.render { writer in
			ProtocolRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			protocol MyProtocol: Sendable, Equatable {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("De-duplicate conformances when rendering extension")
	func deduplicateExtensionConformances() {
		let descriptor = ExtensionDescriptor(
			"Widget",
			conformances: [
				.sendable,
				.equatable,
				.sendable, // should be removed
				.identifier("CustomStringConvertible"),
				.equatable, // should be removed
			]
		) {}
		let output = RenderTest.render { writer in
			ExtensionRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			extension Widget: Sendable, Equatable, CustomStringConvertible {}

			"""
		expectRendered(output, equals: expected)
	}

	// MARK: - Generic Parameters De-duplication

	@Test("De-duplicate generic parameters when rendering struct")
	func deduplicateStructGenericParameters() {
		let descriptor = StructDescriptor(
			"Container",
			genericParameters: [
				"T",
				"U",
				"T", // should be removed
				"V",
				"U", // should be removed
			]
		) {}
		let output = RenderTest.render { writer in
			StructRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			struct Container<T, U, V> {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("De-duplicate generic parameters with constraints keeping first occurrence")
	func deduplicateGenericParametersWithConstraints() {
		let descriptor = StructDescriptor(
			"Container",
			genericParameters: [
				GenericParameterDescriptor("T", constraint: TypeComposition(.equatable)),
				GenericParameterDescriptor("T"), // should be removed
			]
		) {}
		let output = RenderTest.render { writer in
			StructRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			struct Container<T: Equatable> {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("De-duplicate generic parameters when rendering function")
	func deduplicateFunctionGenericParameters() {
		let descriptor = FunctionDescriptor.function(
			name: "process",
			genericParameters: [
				"Element",
				"Element", // should be removed
			]
		)
		let output = RenderTest.render { writer in
			FunctionRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			func process<Element>() {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("De-duplicate generic parameters when rendering protocol")
	func deduplicateProtocolGenericParameters() {
		let descriptor = ProtocolDescriptor(
			"Keyed",
			genericParameters: [
				"Key",
				"Key", // should be removed
			]
		) {}
		let output = RenderTest.render { writer in
			ProtocolRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			protocol Keyed<Key> {}

			"""
		expectRendered(output, equals: expected)
	}

	@Test("De-duplicate generic parameters when rendering enum")
	func deduplicateEnumGenericParameters() {
		let descriptor = PlainEnumDescriptor(
			"Box",
			genericParameters: [
				"Item",
				"Item", // should be removed
			]
		)
		let output = RenderTest.render { writer in
			EnumRenderer.render(descriptor.descriptor, to: &writer)
		}
		let expected = """
			enum Box<Item> {}

			"""
		expectRendered(output, equals: expected)
	}

	// MARK: - Type Composition De-duplication

	@Test("De-duplicate types in typealias composition")
	func deduplicateTypealiasComposition() {
		let descriptor = TypealiasDescriptor(
			"Composite",
			assignedTypes: [
				.sendable,
				.equatable,
				.sendable, // should be removed
				.identifier("Codable"),
				.equatable, // should be removed
			]
		)
		let output = RenderTest.render { writer in
			TypealiasRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			typealias Composite = Sendable & Equatable & Codable

			"""
		expectRendered(output, equals: expected)
	}

	@Test("De-duplicate types in where clause constraints")
	func deduplicateWhereClauseConstraintComposition() {
		let requirement = TypeConstraintDescriptor(
			"T",
			conformsTo: [
				.sendable,
				.equatable,
				.sendable, // should be removed
			]
		)
		let output = CodeRenderingSupport.renderedConstraint(requirement)
		expectRendered(output, equals: "T: Sendable & Equatable")
	}

	@Test("De-duplicate types in protocol associatedtype constraint")
	func deduplicateProtocolAssociatedtypeConstraint() {
		let descriptor = ProtocolDescriptor("Container") {
			ProtocolAssociatedtypeDescriptor(
				"Element",
				conformsTo: [
					.sendable,
					.equatable,
					.sendable, // should be removed
				]
			)
		}
		let output = RenderTest.render { writer in
			ProtocolRenderer.render(descriptor, to: &writer)
		}
		let expected = """
			protocol Container {
			    associatedtype Element: Sendable & Equatable
			}

			"""
		expectRendered(output, equals: expected)
	}

	// MARK: - Closure Attributes De-duplication

	@Test("De-duplicate closure attributes")
	func deduplicateClosureAttributes() {
		let closure = TypeReference.closure(
			parameters: [.int],
			returns: .identifier("Void"),
			attributes: [
				.mainActor,
				.rawValue("Sendable"), // should be removed
				.mainActor, // should be removed
				.sendable, // should be removed
			]
		)
		let output = CodeRenderingSupport.renderedType(closure)
		expectRendered(output, equals: "@MainActor @Sendable (Int) -> Void")
	}

	@Test("De-duplicate escaping attribute when isEscaping is true and attribute is also present")
	func deduplicateEscapingAttribute() {
		let closure = TypeReference.closure(
			parameters: [.int],
			returns: .identifier("Void"),
			isEscaping: true,
			attributes: [
				.rawValue("escaping"), // should be removed
				.escaping, // should be removed
				.rawValue("Sendable"),
			]
		)
		let output = CodeRenderingSupport.renderedType(closure)
		expectRendered(output, equals: "@escaping @Sendable (Int) -> Void")
	}
}

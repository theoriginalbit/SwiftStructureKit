//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct SwiftFileTests {
	@Test("Render an empty file as empty data")
	func renderEmptyFile() {
		let descriptor = SwiftFile {}

		#expect(descriptor.render().isEmpty)
	}

	@Test("Render a file header and top-level declarations")
	func renderFile() throws {
		let descriptor = SwiftFile(
			headerComment: "Generated source.",
			imports: [
				ImportDescriptor("Foundation"),
				ImportDescriptor(
					"SwiftStructureKit",
					submodule: "Descriptors",
					accessModifier: .public,
					attributes: ["_exported", "@preconcurrency"],
				),
				ImportDescriptor(
					"Foundation",
					submodule: "Date",
					kind: .structure,
				),
			],
		) {
			TypeMemberDescriptor.function(name: "greeting", returns: .string) {
				StatementDescriptor.return(.literal(.string("Hello")))
			}

			StructDescriptor("Person") {}

			TypeMemberDescriptor.enum("Status") {
				"active"
			}
		}

		try ReferenceTest.assert(
			descriptor.render(),
			matches: Fixtures.url("SwiftFileTests_renderFile"),
		)
	}

	@Test("Render a complex file sourced from this repo") func renderComplexFile() throws {
		let docCommentDescriptor: TypeReference = .optional(.identifier("DocCommentDescriptor"))
		let accessModifierDescriptor: TypeReference = .optional(.identifier("AccessModifierDescriptor"))

		let descriptor = SwiftFile(headerComment: "Copyright © 2026 SwiftStructureKit. All rights reserved.", imports: [
			.init("OrderedCollections", accessModifier: .public),
		]) {

			StructDescriptor(
				"ProtocolDescriptor",
				comment: """
					A descriptor representing a Swift protocol declaration.

					- Note: Primary associated types are automatically added to `genericParameters`, after explicitly supplied parameters.
					""",
				accessModifier: .public,
				conformances: [.sendable]) {
					PropertyDescriptor.let(
						"comment",
						comment: "The documentation comment attached to the protocol definition, if any.",
						accessModifier: .public,
						type: docCommentDescriptor,
					)

					PropertyDescriptor.let(
						"accessModifier",
						comment: "The access level modifier specified for the protocol, if any.",
						accessModifier: .public,
						type: accessModifierDescriptor,
					)

					PropertyDescriptor.let(
						"attributes",
						comment: "The attributes applied to the protocol.",
						accessModifier: .public,
						type: .array(.identifier("AttributeDescriptor")),
					)

					PropertyDescriptor.let(
						"identifier",
						comment: "The name identifier of the protocol.",
						accessModifier: .public,
						type: .string,
					)

					PropertyDescriptor.let(
						"genericParameters",
						comment: "The generic type parameters declared for the protocol.",
						accessModifier: .public,
						type: .generic("OrderedSet", arguments: ["GenericParameterDescriptor"]),
					)

					PropertyDescriptor.let(
						"genericRequirements",
						comment: "The generic `where` requirements declared by the protocol.",
						accessModifier: .public,
						type: .array(.identifier("TypeConstraintDescriptor")),
					)

					PropertyDescriptor.let(
						"conformances",
						comment: "The type and protocol conformances of the protocol.",
						accessModifier: .public,
						type: .generic("OrderedSet", arguments: ["TypeReference"]),
					)

					TypeMemberDescriptor.property(.let(
						"members",
						comment: "The member declarations contained within the protocol.",
						accessModifier: .public,
						type: .array("ProtocolMemberDescriptor"),
					))

					TypeMemberDescriptor.initializer(
						comment: "Creates a protocol descriptor using a result builder to define its members.",
						parameters: ParametersList {
							Parameter("identifier", label: "_", type: .string)
							Parameter("comment", type: docCommentDescriptor)
							Parameter("accessModifier", type: accessModifierDescriptor)
							Parameter("attributes", type: .generic("Array", arguments: ["AttributeDescriptor"]))
							Parameter("genericParameters", type: .generic("OrderedSet", arguments: ["GenericParameterDescriptor"]))
							Parameter("genericRequirements", type: .generic("Array", arguments: ["TypeConstraintDescriptor"]))
							Parameter("conformances", type: .generic("OrderedSet", arguments: ["TypeReference"]))
							Parameter("members", type: .generic("Array", arguments: ["ProtocolMemberDescriptor"]))
						}) {
							StatementDescriptor.assignment(target: "self.comment", expression: .raw("comment"))
							StatementDescriptor.assignment(target: "self.accessModifier", expression: .raw("accessModifier"))
							StatementDescriptor.assignment(target: "self.attributes", expression: .raw("attributes"))
							StatementDescriptor.assignment(target: "self.identifier", expression: .raw("identifier"))
							StatementDescriptor.assignment(target: "self.genericParameters", expression: .raw("genericParameters"))
							StatementDescriptor.assignment(target: "self.genericRequirements", expression: .raw("genericRequirements"))
							StatementDescriptor.assignment(target: "self.conformances", expression: .raw("conformances"))
							StatementDescriptor.assignment(target: "self.members", expression: .raw("members"))
						}

					TypeMemberDescriptor.initializer(
						comment: """
							Creates a protocol descriptor using a result builder to define its members.
							
							Primary associated types declared by `members` are added to `genericParameters`
							automatically. Explicit generic types retain their order, followed by any
							primary associated types not already present.
							""",
						accessModifier: .public,
						parameters: ParametersList {
							Parameter(
								"identifier",
								label: "_",
								type: .string,
								comment: "The name of the protocol."
							)
							Parameter(
								"comment",
								type: docCommentDescriptor,
								defaultValue: .literal(nil),
								comment: "An optional documentation comment for the protocol."
							)
							Parameter(
								"accessModifier",
								type: accessModifierDescriptor,
								defaultValue: .literal(nil),
								comment: "An optional access level modifier for the protocol."
							)
							Parameter(
								"attributes",
								type: .generic("Array", arguments: ["AttributeDescriptor"]),
								defaultValue: .literal(.array),
								comment: "Attributes applied to the protocol."
							)
							Parameter(
								"genericParameters",
								type: .generic("OrderedSet", arguments: ["GenericParameterDescriptor"]),
								defaultValue: .literal(.array),
								comment: "The generic parameters associated with the protocol."
							)
							Parameter(
								"genericRequirements",
								type: .generic("Array", arguments: ["TypeConstraintDescriptor"]),
								defaultValue: .literal(.array),
								comment: "The generic `where` requirements associated with the protocol."
							)
							Parameter(
								"conformances",
								type: .generic("OrderedSet", arguments: ["TypeReference"]),
								defaultValue: .literal(.array),
								comment: "The types or protocols the protocol inherits from."
							)
							Parameter(
								"members",
								type: .closure(parameters: [], returns: .generic("Array", arguments: ["ProtocolMemberDescriptor"])),
								attributes: [.resultBuilder("ProtocolMemberBuilder")],
								defaultValue: .raw("{ [] }"),
								comment: "A result builder closure producing the protocol's member declarations."
							)
						}) {
							StatementDescriptor.expression(
								.functionCall("self.init") {
									Argument(value: .identifier("identifier"))
									Argument(label: "comment", value: .identifier("comment"))
									Argument(label: "accessModifier", value: .identifier("accessModifier"))
									Argument(label: "attributes", value: .identifier("attributes"))
									Argument(label: "genericParameters", value: .identifier("genericParameters"))
									Argument(label: "genericRequirements", value: .identifier("genericRequirements"))
									Argument(label: "conformances", value: .identifier("conformances"))
									Argument(label: "members", value: .functionCall("members"))
								}
							)
						}
				}

			StructDescriptor("ProtocolPropertyDescriptor", comment: "A property requirement declared by a protocol.", accessModifier: .public, conformances: [.sendable]) {
				PropertyDescriptor.let(
					"comment",
					comment: "The documentation comment attached to the protocol property definition, if any.",
					accessModifier: .public,
					type: docCommentDescriptor
				)
				PropertyDescriptor.let(
					"attributes",
					comment: "The attributes applied to the property.",
					accessModifier: .public,
					type: .generic("Array", arguments: ["AttributeDescriptor"])
				)
				PropertyDescriptor.let(
					"identifier",
					comment: "The name identifier of the protocol property.",
					accessModifier: .public,
					type: .string
				)
				PropertyDescriptor.let(
					"type",
					comment: "The type reference of the protocol property.",
					accessModifier: .public,
					type: .identifier("TypeReference")
				)
				PropertyDescriptor.let(
					"accessorSpecifier",
					comment: "The accessor specifiers for the protocol property.",
					accessModifier: .public,
					type: .identifier("ProtocolPropertyAccessorSpecifier")
				)

				TypeMemberDescriptor.initializer(
					comment: "Creates a protocol property requirement.",
					accessModifier: .public,
					parameters: ParametersList {
						Parameter("comment", type: docCommentDescriptor, comment: "An optional documentation comment for the property.")
						Parameter(
							"attributes",
							type: .generic("Array", arguments: ["AttributeDescriptor"]),
							defaultValue: .literal(.array),
							comment: "Attributes applied to the property."
						)
						Parameter("identifier", type: .string, comment: "The name of the property.")
						Parameter("type", type: "TypeReference", comment: "The property's type.")
						Parameter("accessorSpecifier", type: "ProtocolPropertyAccessorSpecifier", comment: "The required property accessors.")
					}) {
						StatementDescriptor.assignment(target: "self.comment", expression: .raw("comment"))
						StatementDescriptor.assignment(target: "self.attributes", expression: .raw("attributes"))
						StatementDescriptor.assignment(target: "self.identifier", expression: .raw("identifier"))
						StatementDescriptor.assignment(target: "self.type", expression: .raw("type"))
						StatementDescriptor.assignment(target: "self.accessorSpecifier", expression: .raw("accessorSpecifier"))
					}
			}

			TypeMemberDescriptor.enum(
				"ProtocolPropertyAccessorSpecifier",
				comment: "The accessors required by a protocol property.",
				accessModifier: .public,
				conformances: [.sendable]) {
					PlainEnumCaseDescriptor("get", comment: "The property must be readable.")
					PlainEnumCaseDescriptor("getSet", comment: "The property must be readable and settable.")
					PlainEnumCaseDescriptor("borrow", comment: "The property must be borrowable.")
					PlainEnumCaseDescriptor("borrowMutate", comment: "The property must support mutable borrowing.")
				}

			StructDescriptor(
				"ProtocolAssociatedtypeDescriptor",
				comment: "An associated type requirement declared by a protocol.",
				accessModifier: .public,
				conformances: [.sendable]
			) {
				TypeMemberDescriptor.enum("Kind", comment: "A constraint applied to an associated type.", accessModifier: .public, conformances: [.sendable]) {
					AssociatedValueEnumCaseDescriptor(
						"conformsTo",
						associatedValues: [.init(type: "TypeComposition")],
						comment: "The associated type conforms to the specified type."
					)
					AssociatedValueEnumCaseDescriptor(
						"defaultType",
						associatedValues: [.init(type: "TypeReference")],
						comment: "The associated type is the same type as the specified type."
					)
				}
				PropertyDescriptor.let("name", comment: "The associated type's name.", accessModifier: .public, type: .string)
				PropertyDescriptor.let(
					"kind",
					comment: "The associated type's conformance or same-type requirement, if any.",
					accessModifier: .public,
					type: .optional(.identifier("Kind"))
				)
				PropertyDescriptor.let(
					"isPrimary",
					comment: "Whether this associated type is a primary associated type.",
					accessModifier: .public,
					type: .bool
				)

				TypeMemberDescriptor.initializer(
					comment: "Creates an unconstrained associated type requirement.",
					accessModifier: .public,
					parameters: ParametersList {
						Parameter("name", label: "_", type: .string, comment: "The associated type's name.")
					}) {
						StatementDescriptor.assignment(target: "self.name", expression: .raw("name"))
						StatementDescriptor.assignment(target: "self.kind", expression: .literal(nil))
						StatementDescriptor.assignment(target: "self.isPrimary", expression: .literal(false))
					}
				TypeMemberDescriptor.initializer(
					comment: "Creates an associated type requirement constrained to conform to a type.",
					accessModifier: .public,
					parameters: ParametersList {
						Parameter("name", label: "_", type: .string, comment: "The associated type's name.")
						Parameter(
							"other",
							label: "conformsTo",
							type: "TypeReference",
							comment: "The type the associated type must conform to."
						)
						Parameter(
							"isPrimary",
							type: .bool,
							defaultValue: .literal(.boolean(false)),
							comment: "Whether this is a primary associated type."
						)
					}) {
						StatementDescriptor.assignment(target: "self.name", expression: .raw("name"))
						StatementDescriptor.assignment(
							target: "self.kind",
							expression: .functionCall(
								.identifier("Kind.conformsTo"),
								ArgumentsList {
									Argument(
										value: .functionCall(
											.identifier("TypeComposition"),
											ArgumentsList {
												Argument(value: .identifier("other"))
											}
										)
									)
								}
							)
						)
						StatementDescriptor.assignment(target: "self.isPrimary", expression: .raw("isPrimary"))
					}
				TypeMemberDescriptor.initializer(
					comment: "Creates an associated type requirement constrained to conform to a type.",
					accessModifier: .public,
					parameters: ParametersList {
						Parameter("name", label: "_", type: .string, comment: "The associated type's identifier.")
						Parameter(
							"others",
							label: "conformsTo",
							type: .generic("OrderedSet", arguments: ["TypeReference"]),
							comment: "The types the associated type must conform to.",
						)
						Parameter(
							"isPrimary",
							type: .bool,
							defaultValue: .literal(false),
							comment: "Whether this is a primary associated type.",
						)
					}) {
						StatementDescriptor.assignment(target: "self.name", expression: .raw("name"))
						StatementDescriptor.assignment(
							target: "self.kind",
							expression: .functionCall(
								.identifier("Kind.conformsTo"),
								ArgumentsList([
									Argument(
										value: .functionCall(
											.identifier("TypeComposition"),
											ArgumentsList {
												Argument(value: .identifier("others"))
											}
										)
									),
								])
							)
						)
						StatementDescriptor.assignment(target: "self.isPrimary", expression: .raw("isPrimary"))
					}
				TypeMemberDescriptor.initializer(
					comment: "Creates an associated type requirement constrained to conform to a type composition.",
					accessModifier: .public,
					parameters: ParametersList {
						Parameter("name", label: "_", type: .string)
						Parameter("constraint",label: "conformsTo", type: "TypeComposition")
						Parameter("isPrimary", type: .bool, defaultValue: .literal(false))
					}) {
						StatementDescriptor.assignment(target: "self.name", expression: .raw("name"))
						StatementDescriptor.assignment(
							target: "self.kind",
							expression: .functionCall(
								.identifier("Kind.conformsTo"),
								[
									Argument(value: .identifier("constraint"))
								]
							)
						)
						StatementDescriptor.assignment(target: "self.isPrimary", expression: .raw("isPrimary"))
					}
				TypeMemberDescriptor.initializer(
					comment: "Creates an associated type requirement constrained to be another type.",
					accessModifier: .public,
					parameters: ParametersList {
						Parameter("name", label: "_", type: .string, comment: "The associated type's name.")
						Parameter("other", label: "sameTypeAs", type: "TypeReference", comment: "The type the associated type must be identical to.")
						Parameter("isPrimary", type: .bool, defaultValue: .literal(false), comment: "Whether this is a primary associated type.")
					}) {
						StatementDescriptor.assignment(target: "self.name", expression: .raw("name"))
						StatementDescriptor.assignment(
							target: "self.kind",
							expression: .functionCall(.identifier("Kind.defaultType"), [
								Argument(value: .identifier("other"))
							])
						)
						StatementDescriptor.assignment(target: "self.isPrimary", expression: .raw("isPrimary"))
					}
			}

			StructDescriptor(
				"ProtocolTypealiasDescriptor",
				comment: "A typealias declaration within a protocol.",
				accessModifier: .public,
				conformances: [.sendable]
			) {
				PropertyDescriptor.let("descriptor", type: "TypealiasDescriptor")
				PropertyDescriptor.computed("name", comment: "The alias name.", accessModifier: .public, type: .string) {
					StatementDescriptor.return(.raw("descriptor.name"))
				}
				PropertyDescriptor.computed("assignedType", comment: "The type this alias refers to.", accessModifier: .public, type: "TypeComposition") {
					StatementDescriptor.return(.raw("descriptor.assignedType"))
				}

				let supportedAssignedTypes: [(name: String, type: TypeReference)] = [
					("assignedType", "TypeReference"),
					("assignedTypes", .generic("OrderedSet", arguments: ["TypeReference"])),
					("assignedType", "TypeComposition"),
				]

				for assignedType in supportedAssignedTypes {
					TypeMemberDescriptor.initializer(accessModifier: .public, parameters: ParametersList {
						Parameter("name", label: "_", type: .string)
						Parameter("attributes", type: .generic("Array", arguments: ["AttributeDescriptor"]), defaultValue: .literal(.array))
						Parameter(assignedType.name, type: assignedType.type)
					}) {
						StatementDescriptor.assignment(target: "self.descriptor", expression: .functionCall(.identifier("TypealiasDescriptor"), [
							Argument(value: .identifier("name")),
							Argument(label: "attributes", value: .identifier("attributes")),
							Argument(label: assignedType.name, value: .identifier(.init(assignedType.name))),
						]))
					}
				}
			}

			TypeMemberDescriptor.enum(
				"ProtocolMemberDescriptor",
				comment: "A declaration that can appear as a protocol member.",
				accessModifier: .public,
				conformances: [.sendable]) {
					AssociatedValueEnumCaseDescriptor(
						"`associatedtype`",
						associatedValues: [.init(type: "ProtocolAssociatedtypeDescriptor")],
						comment: "An associated type requirement."
					)
					AssociatedValueEnumCaseDescriptor(
						"`typealias`",
						associatedValues: [.init(type: "ProtocolTypealiasDescriptor")],
						comment: "A typealias declaration."
					)
					AssociatedValueEnumCaseDescriptor(
						"property",
						associatedValues: [.init(type: "ProtocolPropertyDescriptor")],
						comment: "A property requirement."
					)
					AssociatedValueEnumCaseDescriptor(
						"function",
						associatedValues: [.init(type: "FunctionSignatureDescriptor")],
						comment: "A function requirement."
					)
				}

			TypeMemberDescriptor.typealias(TypealiasDescriptor(
				"ProtocolMemberBuilder",
				accessModifier: .public,
				assignedType: .generic("ArrayBuilder", arguments: ["ProtocolMemberDescriptor"]),
				comment: "A result builder for assembling protocol member declarations.",
			))
		}

		try ReferenceTest.assert(
			descriptor.render(indentUsing: .tabs),
			matches: Fixtures.url("SwiftFileTests_complexFile"),
		)
	}
}

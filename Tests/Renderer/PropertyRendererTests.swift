//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct PropertyRendererTests {
	@Test("Render properties created with convenience builders")
	func renderPropertiesCreatedWithConvenienceBuilders() {
		let descriptor = StructDescriptor("Convenient") {
			PropertyDescriptor.var(
				"stored",
				type: .int,
				defaultValue: .literal(.integer(0)),
				observers: {
					PropertyAccessorDescriptor.Observer(.didSet(parameterName: nil)) {
						StatementDescriptor.comment("Track changes.")
					}
				},
			)
			PropertyDescriptor.let(
				"constant",
				type: .string,
				defaultValue: .literal(.string("value")),
			)
			PropertyDescriptor.var(
				"computed",
				type: .int,
				getter: {
					StatementDescriptor.return(.literal(.integer(42)))
				},
				setter: {
					StatementDescriptor.comment("Update the value.")
				},
			)
			PropertyDescriptor.computed(
				"asyncValue",
				type: .string,
				getterEffects: EffectSpecifiers<ThrowingSpecifier>(
					isAsync: true,
					throwingSpecifier: .typed(.identifier("ReadError")),
				),
			) {
				StatementDescriptor.return(.literal(.string("value")))
			}
		}
		let output = RenderTest.render { writer in
			StructRenderer.render(descriptor, to: &writer)
		}

		#expect(output == """
			struct Convenient {
			    var stored: Int = 0 {
			        didSet {
			            // Track changes.
			        }
			    }

			    let constant: String = "value"

			    var computed: Int {
			        get {
			            return 42
			        }
			        set {
			            // Update the value.
			        }
			    }

			    var asyncValue: String {
			        get async throws(ReadError) {
			            return "value"
			        }
			    }
			}

			""")
	}

	@Test("Render stored properties")
	func renderStoredProperties() {
		let descriptor = StructDescriptor("Settings") {
			PropertyDescriptor(
				"name",
				comment: "The name.",
				accessModifier: .public,
				type: .string,
				kind: .stored(isMutable: false, defaultValue: .literal(.string("Swift"))),
			)
			PropertyDescriptor(
				"count",
				isStatic: true,
				type: .int,
				kind: .stored(isMutable: true, defaultValue: .literal(.integer(0))),
			)
		}
		let output = RenderTest.render { writer in
			StructRenderer.render(descriptor, to: &writer)
		}

		#expect(output == """
			struct Settings {
			    /// The name.
			    public let name: String = "Swift"

			    static var count: Int = 0
			}

			""")
	}

	@Test("Sanitize property and accessor parameter identifiers")
	func sanitizePropertyAndAccessorIdentifiers() {
		let property = PropertyDescriptor(
			"default",
			type: .string,
			kind: .computed(
				getter: PropertyAccessorDescriptor.Getter(),
				setter: PropertyAccessorDescriptor.Setter(parameterName: "new-value"),
			),
		)
		let output = RenderTest.render { writer in
			PropertyRenderer.render(property, to: &writer)
		}

		#expect(output == """
			var `default`: String {
			    get {
			    }
			    set(new_hyphen_value) {
			    }
			}

			""")
	}

	@Test("Render stored properties with observers")
	func renderStoredPropertiesWithObservers() {
		let property = PropertyDescriptor(
			"value",
			type: .int,
			kind: .stored(
				isMutable: true,
				defaultValue: .literal(.integer(0)),
				observers: [
					PropertyAccessorDescriptor.Observer(.willSet(parameterName: "next")) {
						StatementDescriptor.comment("Observe the incoming value.")
					},
					PropertyAccessorDescriptor.Observer(.didSet(parameterName: nil)) {
						StatementDescriptor.comment("Observe the previous value.")
					},
				],
			),
		)
		let output = RenderTest.render { writer in
			PropertyRenderer.render(property, to: &writer)
		}

		#expect(output == """
			var value: Int = 0 {
			    willSet(next) {
			        // Observe the incoming value.
			    }
			    didSet {
			        // Observe the previous value.
			    }
			}

			""")
	}

	@Test("Render computed property getter and setter")
	func renderComputedProperty() {
		let property = PropertyDescriptor(
			"value",
			accessModifier: .private,
			type: .int,
			kind: .computed(
				getter: PropertyAccessorDescriptor.Getter {
					StatementDescriptor.return(.literal(.integer(42)))
				},
				setter: PropertyAccessorDescriptor.Setter(parameterName: "newValue") {
					StatementDescriptor.assignment(.init(
						isMutable: true,
						identifier: "storedValue",
						type: .int,
						expression: .literal(.integer(42)),
					))
				},
			),
		)
		let output = RenderTest.render { writer in
			PropertyRenderer.render(property, to: &writer)
		}

		#expect(output == """
			private var value: Int {
			    get {
			        return 42
			    }
			    set(newValue) {
			        var storedValue: Int = 42
			    }
			}

			""")
	}

	@Test("Render result builder on a computed property, not its getter")
	func renderResultBuilderOnComputedProperty() {
		let property = PropertyDescriptor.computed(
			"body",
			comment: "The rendered body.",
			attributes: [.resultBuilder("ViewBuilder")],
			type: .identifier("Content"),
		) {
			StatementDescriptor.return(.literal(.string("content")))
		}
		let output = RenderTest.render { writer in
			PropertyRenderer.render(property, to: &writer)
		}

		#expect(output == """
			/// The rendered body.
			@ViewBuilder
			var body: Content {
			    get {
			        return "content"
			    }
			}

			""")
	}

	@Test("Render async getter with typed throws")
	func renderGetterWithTypedThrows() {
		let property = PropertyDescriptor(
			"value",
			type: .string,
			kind: .computed(getter: PropertyAccessorDescriptor.Getter(
				effects: .throws(.identifier("ReadError")),
			)),
		)
		let output = RenderTest.render { writer in
			PropertyRenderer.render(property, to: &writer)
		}

		#expect(output == """
			var value: String {
			    get throws(ReadError) {
			    }
			}

			""")
	}

	@Test("Render async throwing getter")
	func renderAsyncThrowingGetter() {
		let property = PropertyDescriptor(
			"value",
			type: .string,
			kind: .computed(getter: PropertyAccessorDescriptor.Getter(
				effects: EffectSpecifiers<ThrowingSpecifier>(isAsync: true, throwingSpecifier: .throws),
			)),
		)
		let output = RenderTest.render { writer in
			PropertyRenderer.render(property, to: &writer)
		}

		#expect(output == """
			var value: String {
			    get async throws {
			    }
			}

			""")
	}

	@Test("Render async getter")
	func renderAsyncGetter() {
		let property = PropertyDescriptor(
			"value",
			type: .string,
			kind: .computed(getter: PropertyAccessorDescriptor.Getter(
				effects: .async,
			)),
		)
		let output = RenderTest.render { writer in
			PropertyRenderer.render(property, to: &writer)
		}

		#expect(output == """
			var value: String {
			    get async {
			    }
			}

			""")
	}
}

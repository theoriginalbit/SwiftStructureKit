//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An attribute attached to a Swift declaration or parameter.
public struct AttributeDescriptor: Hashable, Sendable {
	public let name: String

	public let arguments: [String]

	/// An attribute.
	///
	/// - Parameters:
	///   - name: The name appearing directly after the `@`. Not validated or sanitised so it may contain generic clauses; `Identifier<Clause>`
	///   - arguments: The optional arguments enclosed in parenthesis; `(arguments-list)`
	public init(_ name: String, arguments: [String] = []) {
		self.name = name.hasPrefix("@") ? String(name.dropFirst()) : name
		self.arguments = arguments
	}
}

public extension AttributeDescriptor {
	/// An attribute name defined by the consumer
	@available(*, deprecated, renamed: "init(_:arguments:)", message: "Use the initializer")
	static func rawValue(_ name: String) -> Self {
		Self(name)
	}

	/// The result builder attribute.
	static var resultBuilder: Self {
		Self("resultBuilder")
	}

	/// A result builder attribute.
	static func resultBuilder(_ name: String) -> Self {
		Self(name)
	}

	/// An availability attribute from a raw string, e.g. `"iOS 17, *"`.
	static func available(_ platforms: String) -> Self {
		Self("available", arguments: [platforms])
	}

	/// An availability attribute built from structured availability arguments.
	///
	/// Use the shorthand form for platform version lists:
	/// ```swift
	/// .available(AvailabilityArgumentsList(iOS: PlatformVersion(16)))
	/// ```
	///
	/// Or use the result builder for the spec form:
	/// ```swift
	/// .available {
	///     .wildcard
	///     .deprecated(PlatformVersion(2, 0))
	///     .message("Use something else")
	/// }
	/// ```
	static func available(_ list: AvailabilityArgumentsList) -> Self {
		let rendered = list.elements.map { argument in
			TokenWriter.render { writer in
				AvailabilityArgumentsListRenderer.render(argument, to: &writer)
			}
		}
		return Self("available", arguments: rendered)
	}

	/// An availability attribute.
	static func available(_ element: AvailabilityArgumentDescriptor, _ elements: AvailabilityArgumentDescriptor...) -> Self {
		.available(AvailabilityArgumentsList(_unchecked: CollectionOfOne(element) + elements))
	}
	/// An Objective-C attribute, optionally naming the Objective-C declaration.
	///
	/// - Parameter objcName: The optional Objective-C name of the declaration.
	static func objectiveC(_ objcName: String?) -> Self {
		if let objcName {
			Self("objc", arguments: [objcName])
		} else {
			Self("objc")
		}
	}

	/// An Objective-C attribute, optionally naming the Objective-C declaration.
	///
	/// - Parameter objcName: The optional Objective-C name of the declaration.
	static func objc(_ objcName: String? = nil) -> Self {
		.objectiveC(objcName)
	}

	/// The `@MainActor` attribute.
	static var mainActor: Self {
		Self("MainActor")
	}

	/// The `@Sendable` attribute.
	static var sendable: Self {
		Self("Sendable")
	}

	/// The `@escaping` attribute.
	static var escaping: Self {
		Self(#function)
	}

	/// The `@frozen` attribute.
	static var frozen: Self {
		Self(#function)
	}

	/// The `@inlinable` attribute.
	static var inlinable: Self {
		Self(#function)
	}

	/// The `@discardableResult` attribute.
	static var discardableResult: Self {
		Self(#function)
	}

	/// The `@_disfavoredOverload` attribute.
	static var disfavoredOverload: Self {
		Self("_disfavoredOverload")
	}

	/// The `@testable` attribute.
	static var testable: Self {
		Self(#function)
	}

	/// The `@_exported` attribute.
	static var exported: Self {
		Self("_exported")
	}
}

extension AttributeDescriptor: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.init(value)
	}
}

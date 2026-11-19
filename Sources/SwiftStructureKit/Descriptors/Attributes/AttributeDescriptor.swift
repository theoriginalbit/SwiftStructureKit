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

	/// An availability attribute with platform and version arguments.
	static func available(_ platforms: String) -> Self {
		Self("available", arguments: [platforms])
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

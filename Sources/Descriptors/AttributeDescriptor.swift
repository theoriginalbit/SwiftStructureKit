//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An attribute attached to a Swift declaration or parameter.
public enum AttributeDescriptor: Hashable, Sendable {
	/// An attribute name defined by the consumer
	case rawValue(String)

	/// A result builder attribute.
	case resultBuilder(String)

	/// An availability attribute with platform and version arguments.
	case available(String)

	/// An Objective-C attribute, optionally naming the Objective-C declaration.
	case objectiveC(name: String?)

	/// The `@MainActor` attribute.
	case mainActor

	/// The `@Sendable` attribute.
	case sendable

	/// The `@escaping` attribute.
	case escaping

	/// The `@frozen` attribute.
	case frozen

	/// The `@inlinable` attribute.
	case inlinable

	/// The `@discardableResult` attribute.
	case discardableResult

	/// The `@_disfavoredOverload` attribute.
	case disfavoredOverload

	/// The `@testable` attribute.
	case testable

	/// The `@_exported` attribute.
	case exported

	/// A custom attribute name
	public init(_ value: String) {
		self = .rawValue(value)
	}
}

extension AttributeDescriptor: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self = .rawValue(value)
	}
}

public extension AttributeDescriptor {
	/// Creates an Objective-C attribute with an optional name.
	static func objc(name: String? = nil) -> Self {
		.objectiveC(name: name)
	}
}

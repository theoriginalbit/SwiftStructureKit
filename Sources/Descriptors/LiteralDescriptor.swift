//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a literal value in Swift source code.
public enum LiteralDescriptor: Equatable, Sendable {
	/// A string literal value.
	case string(String)

	/// An integer literal value.
	case integer(Int)

	/// A boolean literal value.
	case boolean(Bool)

	/// A floating-point literal value.
	case double(Double)

	/// A `nil` literal value.
	case `nil`

	/// An empty array literal value.
	case array

	/// An empty dictionary literal value.
	case dictionary
}

extension LiteralDescriptor: ExpressibleByStringLiteral {
	/// Creates a literal from a string literal, producing a ``LiteralDescriptor/string(_:)`` value.
	public init(stringLiteral value: StringLiteralType) {
		self = .string(value)
	}
}

extension LiteralDescriptor: ExpressibleByIntegerLiteral {
	/// Creates a literal from an integer literal, producing a ``LiteralDescriptor/integer(_:)`` value.
	public init(integerLiteral value: IntegerLiteralType) {
		self = .integer(value)
	}
}

extension LiteralDescriptor: ExpressibleByBooleanLiteral {
	/// Creates a literal from a boolean literal, producing a ``LiteralDescriptor/boolean(_:)`` value.
	public init(booleanLiteral value: BooleanLiteralType) {
		self = .boolean(value)
	}
}

extension LiteralDescriptor: ExpressibleByFloatLiteral {
	/// Creates a literal from a floating-point literal, producing a ``LiteralDescriptor/double(_:)`` value.
	public init(floatLiteral value: FloatLiteralType) {
		self = .double(Double(value))
	}
}

extension LiteralDescriptor: ExpressibleByNilLiteral {
	/// Creates a literal from a `nil` literal, producing a ``LiteralDescriptor/nil`` value.
	public init(nilLiteral: ()) {
		self = .nil
	}
}

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
	public init(stringLiteral value: StringLiteralType) {
		self = .string(value)
	}
}

extension LiteralDescriptor: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: IntegerLiteralType) {
		self = .integer(value)
	}
}

extension LiteralDescriptor: ExpressibleByBooleanLiteral {
	public init(booleanLiteral value: BooleanLiteralType) {
		self = .boolean(value)
	}
}

extension LiteralDescriptor: ExpressibleByFloatLiteral {
	public init(floatLiteral value: FloatLiteralType) {
		self = .double(Double(value))
	}
}

extension LiteralDescriptor: ExpressibleByNilLiteral {
	public init(nilLiteral: ()) {
		self = .nil
	}
}

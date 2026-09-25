//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a literal value in Swift source code.
public enum LiteralDescriptor: Sendable {
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
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public enum IntegerLiteral: Equatable, Sendable {
	case decimal(Int)
	case hexadecimal(Int)
	case binary(Int)
	case octal(Int)
}

public extension LiteralDescriptor {
	/// An integer literal value.
	static func integer(_ value: Int) -> Self {
		.integer(.decimal(value))
	}
}

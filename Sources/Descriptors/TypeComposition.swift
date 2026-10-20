//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A composition of types joined by `&`.
public struct TypeComposition: Hashable, Sendable, ExpressibleByArrayLiteral {
	public let types: [TypeReference]

	public init(_ type: TypeReference) {
		self.types = [type]
	}

	public init(_ types: [TypeReference]) {
		self.types = types
	}

	public init(arrayLiteral elements: TypeReference...) {
		self.init(elements)
	}
}

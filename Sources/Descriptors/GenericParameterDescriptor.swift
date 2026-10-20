//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A generic parameter and its optional inline conformance constraint.
public struct GenericParameterDescriptor: Hashable, Sendable, ExpressibleByStringLiteral {
	public let identifier: TypeIdentifier
	public let constraint: TypeComposition?

	public init(_ identifier: TypeIdentifier, constraint: TypeComposition? = nil) {
		self.identifier = identifier
		self.constraint = constraint
	}

	public init(_ identifier: String, constraint: TypeComposition? = nil) {
		self.init(TypeIdentifier(identifier), constraint: constraint)
	}

	public init(_ identifier: String, constraint: TypeReference...) {
		self.init(TypeIdentifier(identifier), constraint: TypeComposition(constraint))
	}

	public init(stringLiteral value: String) {
		self.init(value)
	}
}

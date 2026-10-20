//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A generic `where` requirement constraining a type to a composition.
public struct TypeConstraintDescriptor: Hashable, Sendable {
	/// A constraint applied to the constraint.
	public enum Kind: Hashable, Sendable {
		/// The constraint represents conforming `Foo: Bar`.
		case conformsTo(TypeComposition)

		/// The constraint represents same-type `Foo == Bar`.
		case sameType(TypeComposition)
	}

	public let type: TypeIdentifier
	public let kind: Kind

	public init(_ type: TypeIdentifier, conformsTo constraint: TypeReference) {
		self.type = type
		self.kind = .conformsTo(TypeComposition(constraint))
	}

	public init(_ type: TypeIdentifier, conformsTo constraint: TypeComposition) {
		self.type = type
		self.kind = .conformsTo(constraint)
	}

	public init(_ type: TypeIdentifier, conformsTo constraints: [TypeReference]) {
		self.type = type
		self.kind = .conformsTo(TypeComposition(constraints))
	}

	public init(_ type: TypeIdentifier, sameType constraint: TypeReference) {
		self.type = type
		self.kind = .sameType(TypeComposition(constraint))
	}

	public init(_ type: TypeIdentifier, sameType constraint: TypeComposition) {
		self.type = type
		self.kind = .sameType(constraint)
	}

	public init(_ type: TypeIdentifier, sameType constraints: [TypeReference]) {
		self.type = type
		self.kind = .sameType(TypeComposition(constraints))
	}
}

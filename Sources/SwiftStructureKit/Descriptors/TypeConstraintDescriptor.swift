//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// Describes a generic `where` requirement on a type.
public struct TypeConstraintDescriptor: Sendable {
	/// The relationship expressed by a type constraint.
	public enum Kind: Sendable {
		/// Requires the constrained type to conform to the specified type or composition.
		case conformsTo(TypeComposition)

		/// Requires the constrained type to be identical to the specified type or composition.
		case sameType(TypeComposition)
	}

	/// The identifier of the type being constrained.
	public let type: TypeIdentifier

	/// The relationship and type composition required of ``type``.
	public let kind: Kind

	/// Creates a conformance requirement for a single type.
	///
	/// - Parameters:
	///   - type: The identifier of the type being constrained.
	///   - constraint: The type that ``type`` must conform to.
	public init(_ type: TypeIdentifier, conformsTo constraint: TypeReference) {
		self.type = type
		self.kind = .conformsTo(TypeComposition(constraint))
	}

	/// Creates a conformance requirement for a type composition.
	///
	/// - Parameters:
	///   - type: The identifier of the type being constrained.
	///   - constraint: The type composition that ``type`` must conform to.
	public init(_ type: TypeIdentifier, conformsTo constraint: TypeComposition) {
		self.type = type
		self.kind = .conformsTo(constraint)
	}

	/// Creates a conformance requirement from multiple types.
	///
	/// - Parameters:
	///   - type: The identifier of the type being constrained.
	///   - constraints: The types that make up the composition ``type`` must conform to.
	public init(_ type: TypeIdentifier, conformsTo constraints: [TypeReference]) {
		self.type = type
		self.kind = .conformsTo(TypeComposition(constraints))
	}

	/// Creates a same-type requirement for a single type.
	///
	/// - Parameters:
	///   - type: The identifier of the type being constrained.
	///   - constraint: The type that ``type`` must be identical to.
	public init(_ type: TypeIdentifier, sameType constraint: TypeReference) {
		self.type = type
		self.kind = .sameType(TypeComposition(constraint))
	}

	/// Creates a same-type requirement for a type composition.
	///
	/// - Parameters:
	///   - type: The identifier of the type being constrained.
	///   - constraint: The type composition that ``type`` must be identical to.
	public init(_ type: TypeIdentifier, sameType constraint: TypeComposition) {
		self.type = type
		self.kind = .sameType(constraint)
	}

	/// Creates a same-type requirement from multiple types.
	///
	/// - Parameters:
	///   - type: The identifier of the type being constrained.
	///   - constraints: The types that make up the composition ``type`` must be identical to.
	public init(_ type: TypeIdentifier, sameType constraints: [TypeReference]) {
		self.type = type
		self.kind = .sameType(TypeComposition(constraints))
	}
}

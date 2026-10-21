//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A composition of types joined by `&`.
///
/// Use this type to represent a Swift protocol composition such as
/// `Sendable & Equatable`.
public struct TypeComposition: Equatable, Sendable {
	/// The types that make up the composition.
	public let types: [TypeReference]

	/// Creates a composition containing a single type.
	///
	/// - Parameter type: The type to include in the composition.
	public init(_ type: TypeReference) {
		self.types = [type]
	}

	/// Creates a composition containing the specified types.
	///
	/// - Parameter types: The types to include in the composition.
	public init(_ types: [TypeReference]) {
		self.types = types
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public enum MetatypeReference: Hashable, Sendable {
	/// The `.Type` metatype.
	case type(TypeReference)

	/// The `.Protocol` metatype.
	case `protocol`(TypeReference)
}

public extension TypeReference {
	/// The current type's `.Type` metatype.
	var typeMetatype: Self {
		Self.metatype(.type(self))
	}

	/// The current type's `.Protocol` metatype.
	var protocolMetatype: Self {
		Self.metatype(.protocol(self))
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A description of an access modifier.
public enum AccessModifierDescriptor: Sendable {
	/// A declaration extensible outside of the module.
	case open

	/// A declaration accessible outside of the module.
	case `public`

	/// A declaration accessible outside of the module, but only inside the containing package or project.
	case package

	/// A declaration only accessible inside of the module.
	case `internal`

	/// A declaration only accessible inside the same Swift file.
	case `fileprivate`

	/// A declaration only accessible inside the same type or scope.
	case `private`
}

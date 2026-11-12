//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A description of an access modifier applicable for a class.
public enum ClassAccessModifierDescriptor: Sendable {
	/// A declaration extendable outside of the module.
	case `open`

	/// A standard access modifier.
	case base(AccessModifierDescriptor)

	/// A declaration accessible outside of the module.
	public static var `public`: Self { .base(.public) }

	/// A declaration accessible outside of the module, but only inside the containing package or project.
	public static var package: Self { .base(.package) }

	/// A declaration only accessible inside of the module.
	public static var `internal`: Self { .base(.internal) }

	/// A declaration only accessible inside the same Swift file.
	public static var `fileprivate`: Self { .base(.fileprivate) }

	/// A declaration only accessible inside the same type or scope.
	public static var `private`: Self { .base(.private) }
}

extension ClassAccessModifierDescriptor: CaseIterable {
	public static var allCases: [Self] {
		[.open] + AccessModifierDescriptor.allCases.map(Self.base)
	}
}

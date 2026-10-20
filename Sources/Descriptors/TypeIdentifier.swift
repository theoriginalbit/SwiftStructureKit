//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A qualified Swift type name, represented as independently sanitized components.
public struct TypeIdentifier: Hashable, Sendable, ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
	/// The components making up the qualified type name.
	public let components: [String]

	public init(_ identifier: String) {
		self.components = identifier.split(separator: ".", omittingEmptySubsequences: false).map(String.init)
	}

	public init(_ components: [String]) {
		self.components = components
	}

	public init(stringLiteral value: String) {
		self.init(value)
	}

	public init(arrayLiteral elements: String...) {
		self.components = elements
	}
}

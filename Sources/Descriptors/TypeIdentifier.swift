//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A qualified Swift type name represented as dot-separated components.
///
/// For example, `TypeIdentifier("Module.Model")` has the components
/// `["Module", "Model"]`.
public struct TypeIdentifier: Hashable, Sendable, ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
	/// The ordered components making up the qualified type name.
	public let components: [String]

	/// Creates a type identifier by splitting a qualified name at each period.
	///
	/// Empty components are preserved. For example, `".Model"` produces
	/// `["", "Model"]`.
	///
	/// - Parameter identifier: The qualified type name to split.
	public init(_ identifier: String) {
		self.components = identifier.split(separator: ".", omittingEmptySubsequences: false).map(String.init)
	}

	/// Creates a type identifier from its already-separated components.
	///
	/// - Parameter components: The ordered components of the qualified type name.
	public init(_ components: [String]) {
		self.components = components
	}

	/// Creates a type identifier from a string literal.
	///
	/// The literal is split at periods in the same way as ``init(_:)-(String)``.
	///
	/// - Parameter value: The qualified type name.
	public init(stringLiteral value: String) {
		self.init(value)
	}

	/// Creates a type identifier from an array literal of components.
	///
	/// Each literal element is used as one component and is not split at periods.
	///
	/// - Parameter elements: The ordered components of the qualified type name.
	public init(arrayLiteral elements: String...) {
		self.components = elements
	}
}

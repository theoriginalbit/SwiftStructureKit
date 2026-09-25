//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// The effect specifiers of a function, such as `async` and throwing behavior.
public struct EffectSpecifiers: Sendable {
	/// The throwing behavior of a function.
	public enum ThrowingSpecifier: Sendable {
		/// A function that can throw an error (`throws`).
		case `throws`

		/// A function that rethrows errors thrown by its closure parameters (`rethrows`).
		case `rethrows`

		/// A function that throws a specific error type (`throws(MyError)`).
		case typed(TypeReference)
	}

	/// Whether the function is asynchronous (`async`).
	public var isAsync: Bool

	/// The throwing behavior of the function (`throws` or `rethrows`), if any.
	public var throwingSpecifier: ThrowingSpecifier?

	/// Creates an effect specifier set.
	///
	/// - Parameters:
	///   - isAsync: Whether the function is asynchronous.
	///   - throwingSpecifier: The throwing behavior of the function, if any.
	public init(
		isAsync: Bool = false,
		throwingSpecifier: ThrowingSpecifier? = nil
	) {
		assert(isAsync || throwingSpecifier != nil, "Effect requires at least one of `async` or a throwing specifier")
		self.isAsync = isAsync
		self.throwingSpecifier = throwingSpecifier
	}
}

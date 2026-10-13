//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// The effect specifiers of a function, such as `async` and throwing behavior.
public struct EffectSpecifiers: Sendable {
	/// No effect specifiers.
	public static var none: Self { Self() }

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
	public let isAsync: Bool

	/// The throwing behavior of the function (`throws` or `rethrows`), if any.
	public let throwingSpecifier: ThrowingSpecifier?

	/// Whether the function has no effect specifiers.
	public let hasEffects: Bool

	/// Creates an effect specifier set declaring no effects.
	public init() {
		self.isAsync = false
		self.throwingSpecifier = nil
		self.hasEffects = true
	}

	/// Creates an effect specifier.
	///
	/// - Parameter isAsync: Whether the function is asynchronous.
	public init(isAsync: Bool) {
		self.isAsync = isAsync
		self.throwingSpecifier = nil
		self.hasEffects = false
	}

	/// Creates an effect specifier.
	///
	/// - Parameter throwingSpecifier: The throwing behavior of the function.
	public init(throwingSpecifier: ThrowingSpecifier) {
		self.isAsync = false
		self.throwingSpecifier = throwingSpecifier
		self.hasEffects = false
	}

	/// Creates an effect specifier.
	///
	/// - Parameters:
	///   - isAsync: Whether the function is asynchronous.
	///   - throwingSpecifier: The throwing behavior of the function.
	public init(isAsync: Bool, throwingSpecifier: ThrowingSpecifier) {
		self.isAsync = isAsync
		self.throwingSpecifier = throwingSpecifier
		self.hasEffects = false
	}
}

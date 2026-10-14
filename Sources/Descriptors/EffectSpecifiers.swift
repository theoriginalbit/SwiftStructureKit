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
	public let isAsync: Bool

	/// The throwing behavior of the function (`throws` or `rethrows`), if any.
	public let throwingSpecifier: ThrowingSpecifier?

	/// Whether the function has no effect specifiers.
	public var hasEffects: Bool {
		isAsync || throwingSpecifier != nil
	}

	/// Creates an effect specifier.
	///
	/// - Parameters:
	///   - isAsync: Whether the function is asynchronous.
	///   - throwingSpecifier: The throwing behavior of the function.
	public init(isAsync: Bool = false, throwingSpecifier: ThrowingSpecifier? = nil) {
		self.isAsync = isAsync
		self.throwingSpecifier = throwingSpecifier
	}
}

public extension EffectSpecifiers {
	/// No effect specifiers.
	static var none: Self { Self() }

	/// Creates an effect specifier.
	static var async: Self { Self(isAsync: true) }

	/// Creates an effect specifier.
	static var `throws`: Self { Self(throwingSpecifier: .throws) }

	/// Creates an effect specifier that declares throws a specific error type (`throws(MyError)`).
	static func `throws`(_ type: TypeReference) -> Self { Self(throwingSpecifier: .typed(type)) }

	/// Creates an effect specifier.
	static var `rethrows`: Self { Self(throwingSpecifier: .rethrows) }
}

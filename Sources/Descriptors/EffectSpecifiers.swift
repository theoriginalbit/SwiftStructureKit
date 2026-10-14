//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public protocol ThrowingSpecifierDescriptor: Hashable, Sendable {}

/// The throwing behavior available to closures and property getters.
public enum ThrowingSpecifier: ThrowingSpecifierDescriptor {
	/// Can throw an error (`throws`).
	case `throws`

	/// Throws a specific error type (`throws(MyError)`).
	case typed(TypeReference)
}

/// The throwing behavior available to function declarations.
public enum FunctionThrowingSpecifier: ThrowingSpecifierDescriptor {
	/// A function that can throw an error (`throws`).
	case `throws`

	/// A function that rethrows errors thrown by its closure parameters (`rethrows`).
	case `rethrows`

	/// A function that throws a specific error type (`throws(MyError)`).
	case typed(TypeReference)
}

/// The asynchronous and throwing behavior of a declaration or type.
public struct EffectSpecifiers<Throwing: ThrowingSpecifierDescriptor>: Hashable, Sendable {
	/// Whether the operation is asynchronous (`async`).
	public let isAsync: Bool

	/// The throwing behavior, if any.
	public let throwingSpecifier: Throwing?

	/// Whether there are no effect specifiers.
	public var hasEffects: Bool {
		isAsync || throwingSpecifier != nil
	}

	/// Creates effect specifiers.
	///
	/// - Parameters:
	///   - isAsync: Whether the operation is asynchronous.
	///   - throwingSpecifier: The throwing behavior.
	public init(isAsync: Bool = false, throwingSpecifier: Throwing? = nil) {
		self.isAsync = isAsync
		self.throwingSpecifier = throwingSpecifier
	}
}

public extension EffectSpecifiers {
	/// No effect specifiers.
	static var none: Self { Self() }

	/// Creates an effect specifier.
	static var async: Self { Self(isAsync: true) }
}

public extension EffectSpecifiers where Throwing == ThrowingSpecifier {
	/// Creates an effect specifier.
	static var `throws`: Self { Self(throwingSpecifier: .throws) }

	/// Creates an effect specifier that declares throws a specific error type (`throws(MyError)`).
	static func `throws`(_ type: TypeReference) -> Self { Self(throwingSpecifier: .typed(type)) }
}

public extension EffectSpecifiers where Throwing == FunctionThrowingSpecifier {
	/// Creates an effect specifier.
	static var `throws`: Self { Self(throwingSpecifier: .throws) }

	/// Creates an effect specifier.
	static var `rethrows`: Self { Self(throwingSpecifier: .rethrows) }

	/// Creates an effect specifier that declares throws a specific error type (`throws(MyError)`).
	static func `throws`(_ type: TypeReference) -> Self { Self(throwingSpecifier: .typed(type)) }
}

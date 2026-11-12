//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// The accessor declarations that can appear in a property.
public enum PropertyAccessorDescriptor {
	/// A property getter.
	public struct Getter: Sendable {
		/// The effects declared by the getter.
		public let effects: EffectSpecifiers<ThrowingSpecifier>

		/// The statements in the getter body.
		public let body: CodeBlockDescriptor

		/// Creates a property getter.
		///
		/// - Parameters:
		///   - effects: The getter's `async` and throwing specifiers.
		///   - body: A result builder closure producing the getter body.
		public init(
			effects: EffectSpecifiers<ThrowingSpecifier> = .none,
			@CodeBlockBuilder body: () -> [StatementDescriptor] = { [] },
		) {
			self.effects = effects
			self.body = CodeBlockDescriptor(body)
		}
	}

	/// A property setter.
	public struct Setter: Sendable {
		/// The setter's optional source-level parameter name.
		public let parameterName: String?

		/// The statements in the setter body.
		public let body: CodeBlockDescriptor

		/// Creates a property setter.
		///
		/// - Parameters:
		///   - parameterName: An optional name for the new value.
		///   - body: A result builder closure producing the setter body.
		public init(
			parameterName: String? = nil,
			@CodeBlockBuilder body: () -> [StatementDescriptor] = { [] },
		) {
			self.parameterName = parameterName
			self.body = CodeBlockDescriptor(body)
		}
	}

	/// A stored property's `willSet` or `didSet` observer.
	public struct Observer: Sendable {
		/// The observer kind and its optional source-level parameter name.
		public enum Kind: Sendable {
			/// A `willSet` property observer.
			case willSet(parameterName: String? = nil)

			/// A `didSet` property observer.
			case didSet(parameterName: String? = nil)
		}

		/// The observer kind.
		public let kind: Kind

		/// The statements in the observer body.
		public let body: CodeBlockDescriptor

		/// Creates a stored property observer.
		///
		/// - Parameters:
		///   - kind: The observer kind.
		///   - body: A result builder closure producing the observer body.
		public init(
			_ kind: Kind,
			@CodeBlockBuilder body: () -> [StatementDescriptor],
		) {
			self.kind = kind
			self.body = CodeBlockDescriptor(body)
		}

		/// Creates a `willSet` observer.
		///
		/// - Parameters:
		///   - parameterName: An optional name for the incoming value.
		///   - body: A result builder closure producing the observer body.
		public static func willSet(
			parameterName: String? = nil,
			@CodeBlockBuilder body: () -> [StatementDescriptor]
		) -> Self {
			Self(.willSet(parameterName: parameterName), body: body)
		}

		/// Creates a `didSet` observer.
		///
		/// - Parameters:
		///   - parameterName: An optional name for the previous value.
		///   - body: A result builder closure producing the observer body.
		public static func didSet(
			parameterName: String? = nil,
			@CodeBlockBuilder body: () -> [StatementDescriptor]
		) -> Self {
			Self(.didSet(parameterName: parameterName), body: body)
		}
	}

}

/// A result builder for composing stored-property observers.
public typealias PropertyObserversBuilder = ArrayBuilder<PropertyAccessorDescriptor.Observer>

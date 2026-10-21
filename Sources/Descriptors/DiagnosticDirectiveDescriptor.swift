//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A Swift compiler diagnostic directive such as `#warning` or `#error`.
public struct DiagnosticDirectiveDescriptor: Sendable {
	/// The kind of diagnostic directive to render.
	public enum Kind: Sendable {
		/// Emits a compiler warning (`#warning`).
		case warning

		/// Emits a compiler error (`#error`).
		case error
	}

	/// The diagnostic directive to emit.
	public let kind: Kind

	/// The message passed to the compiler directive.
	public let message: String

	/// Creates a diagnostic directive.
	///
	/// - Parameters:
	///   - kind: Whether to emit a warning or an error.
	///   - message: The diagnostic message.
	public init(_ kind: Kind, message: String) {
		self.kind = kind
		self.message = message
	}
}

public extension DiagnosticDirectiveDescriptor {
	/// Creates a warning diagnostic.
	///
	/// - Parameter message: The warning message.
	/// - Returns: A warning diagnostic descriptor.
	static func warning(_ message: String) -> Self {
		Self(.warning, message: message)
	}

	/// Creates an error diagnostic.
	///
	/// - Parameter message: The error message.
	/// - Returns: An error diagnostic descriptor.
	static func error(_ message: String) -> Self {
		Self(.error, message: message)
	}
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: DiagnosticDirectiveDescriptor) -> Result {
		[.diagnostic(expression)]
	}
}

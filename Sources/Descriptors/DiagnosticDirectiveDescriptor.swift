//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public struct DiagnosticDirectiveDescriptor: Sendable {
	public enum Kind: Sendable {
		case warning, error
	}

	public let kind: Kind
	public let message: String

	public init(_ kind: Kind, message: String) {
		self.kind = kind
		self.message = message
	}
}

public extension DiagnosticDirectiveDescriptor {
	static func warning(_ message: String) -> Self {
		Self(.warning, message: message)
	}

	static func error(_ message: String) -> Self {
		Self(.error, message: message)
	}
}

extension ArrayBuilder where T == StatementDescriptor {
	public static func buildExpression(_ expression: DiagnosticDirectiveDescriptor) -> Result {
		[.diagnostic(expression)]
	}
}

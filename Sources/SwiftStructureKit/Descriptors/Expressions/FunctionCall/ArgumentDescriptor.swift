//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An argument passed to a function call expression.
public typealias Argument = ArgumentDescriptor

/// An argument passed to a function call expression.
public struct ArgumentDescriptor: Sendable {
	/// The optional argument label.
	public let label: String?

	/// The argument expression.
	public let value: ExpressionDescriptor

	/// Creates a function call argument.
	///
	/// - Parameters:
	///   - label: The optional argument label.
	///   - value: The argument expression.
	public init(label: String? = nil, value: ExpressionDescriptor) {
		self.label = label
		self.value = value
	}
}

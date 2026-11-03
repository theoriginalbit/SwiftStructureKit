//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing an associated value attached to an enum case.
public struct EnumCaseAssociatedValueDescriptor: Sendable {
	/// The optional label for the associated value.
	public let label: String?

	/// The type of the associated value.
	public let type: TypeReference

	/// An optional default value of the associated value.
	public let defaultValue: ExpressionDescriptor?

	/// Creates an associated value descriptor with an optional label, type, and optional default value.
	///
	/// - Parameters:
	///   - label: An optional argument label for the associated value.
	///   - type: The type reference of the associated value.
	///   - defaultValue: An optional default value for the associated value.
	public init(
		label: String? = nil,
		type: TypeReference,
		defaultValue: ExpressionDescriptor? = nil,
	) {
		self.label = label
		self.type = type
		self.defaultValue = defaultValue
	}
}

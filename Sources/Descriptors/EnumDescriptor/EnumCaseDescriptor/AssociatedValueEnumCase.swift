//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A convenience type alias for an enum case descriptor within an associated-value enumeration.
public typealias AssociatedValueEnumCase = EnumCaseDescriptor<AssociatedValueEnumMode>

/// An enum kind representing enumerations that use associated values.
public struct AssociatedValueEnumMode: EnumMode {}

/// A descriptor representing an associated value attached to an enum case.
public struct AssociatedValueDescriptor: Sendable {
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

// MARK: - Enum Case Construction Conveniences

extension EnumCaseDescriptor where Self == AssociatedValueEnumCase {
	/// Creates an associated-value enum case with associated values and an optional documentation comment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - associatedValues: The associated values for the case.
	///   - comment: An optional documentation comment for the case.
	public init(_ name: String, associatedValues: [AssociatedValueDescriptor], comment: DocCommentDescriptor? = nil) {
		self.name = name
		self.rawValue = nil
		self.associatedValues = associatedValues
		self.comment = comment
	}
}

extension ArrayBuilder where T == AssociatedValueEnumCase {
	/// Represents an enum case without associated values within an enum that
	/// has other cases that use associated values.
	///
	/// - Parameter statement: The name of the enum case.
	/// - Returns: A result array containing the constructed `AssociatedValueEnumCase`.
	public static func buildExpression(_ statement: String) -> Result {
		[EnumCaseDescriptor(statement, associatedValues: [])]
	}
}

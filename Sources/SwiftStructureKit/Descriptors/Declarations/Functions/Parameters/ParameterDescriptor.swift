//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A function parameter.
public typealias Parameter = ParameterDescriptor

/// A parameter in a parameter list.
public struct ParameterDescriptor: Sendable {
	/// The optional label that is used on the call-site.
	public let label: String?

	/// The variable name that would be used in the code block.
	public let identifier: String

	/// The Swift type of the parameter.
	public let type: TypeReference

	/// Whether the parameter is passed by reference using `inout`.
	public let isInout: Bool

	/// The declaration attributes applied to the parameter, rendered in front of the label.
	///
	/// Only attributes that attach to the parameter declaration itself belong here, such as
	/// result builders (`@ViewBuilder`) or property wrappers. Attributes that form part of
	/// the parameter's *type*, such as `@escaping`, `@Sendable`, or `@MainActor` on a closure,
	/// must be expressed on ``type`` instead.
	///
	/// - SeeAlso: ``TypeReference/closure(parameters:returns:isEscaping:attributes:effects:)``
	public let attributes: [AttributeDescriptor]

	/// An optional default value of the parameter.
	public let defaultValue: ExpressionDescriptor?

	/// A description of the parameter that will be included in the function doc comment.
	///
	/// If the function's doc comment is `nil` and this is non-`nil` then this
	/// will be ignored.
	public let comment: InlineCommentDescriptor?

	/// Creates a parameter.
	///
	/// - Parameters:
	///   - identifier: The variable name used within the function body.
	///   - label: The optional label used at the call site.
	///   - type: The Swift type of the parameter.
	///   - isInout: Whether the parameter is passed by reference using `inout`.
	///   - attributes: The attributes applied to the parameter.
	///   - defaultValue: An optional default value expression for the parameter.
	///   - comment: An optional inline comment describing the parameter.
	public init(
		_ identifier: String,
		label: String? = nil,
		type: TypeReference,
		isInout: Bool = false,
		attributes: [AttributeDescriptor] = [],
		defaultValue: ExpressionDescriptor? = nil,
		comment: InlineCommentDescriptor? = nil
	) {
		self.label = label
		self.identifier = identifier
		self.type = type
		self.isInout = isInout
		self.attributes = attributes
		self.defaultValue = defaultValue
		self.comment = comment
	}
}

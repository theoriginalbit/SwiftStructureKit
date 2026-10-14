//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A function parameter.
public typealias Parameter = ParametersList.Parameter

/// A list of parameters enclosed in parentheses.
public struct ParametersList: Sendable {
	/// A parameter in a parameter list.
	public struct Parameter: Sendable {
		/// The optional label that is used on the callsite.
		public let label: String?

		/// The variable name that would be used in the code block.
		public let identifier: String

		/// The Swift type of the parameter.
		public let type: TypeReference

		/// Whether the parameter is passed by reference using `inout`.
		public let isInout: Bool

		/// The attributes applied to the parameter.
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
		///   - isEscaping: Whether a closure parameter may escape the function body.
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

	/// The parameters in the list.
	public let parameters: [Parameter]

	/// Creates a list of parameters.
	public init(_ parameters: [Parameter] = []) {
		self.parameters = parameters
	}

	/// Creates a list of parameters.
	public init(@ArrayBuilder<Parameter> _ parameters: () -> [Parameter]) {
		self.parameters = parameters()
	}
}

extension ParametersList: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Parameter...) {
		self.parameters = elements
	}
}

extension ParametersList: RandomAccessCollection {
	public var startIndex: Int {
		parameters.startIndex
	}

	public var endIndex: Int {
		parameters.endIndex
	}

	public subscript(position: Int) -> Parameter {
		parameters[position]
	}
}

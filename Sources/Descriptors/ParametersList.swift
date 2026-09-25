//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

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
		///   - label: The optional label used at the call site.
		///   - identifier: The variable name used within the function body.
		///   - type: The Swift type of the parameter.
		///   - defaultValue: An optional default value expression for the parameter.
		///   - comment: An optional inline comment describing the parameter.
		public init(
			label: String? = nil,
			_ identifier: String,
			type: TypeReference,
			defaultValue: ExpressionDescriptor? = nil,
			comment: InlineCommentDescriptor? = nil
		) {
			self.label = label
			self.identifier = identifier
			self.type = type
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

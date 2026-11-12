//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A list of parameters enclosed in parentheses.
public struct ParametersList: Sendable {
	/// A parameter in a parameter list.
	public typealias Parameter = ParameterDescriptor

	/// The parameters in the list.
	public let parameters: [Parameter]

	/// A list of parameters.
	///
	/// - Parameter parameters: The parameters in the list.
	public init(_ parameters: [Parameter] = []) {
		self.parameters = parameters
	}

	/// Creates a list of parameters.
	///
	/// - Parameter parameters: The parameters in the list.
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

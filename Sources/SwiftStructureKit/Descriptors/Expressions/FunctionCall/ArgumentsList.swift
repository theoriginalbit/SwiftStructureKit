//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An argument passed to a function call expression.
public typealias Argument = ArgumentsList.Argument

/// A list of arguments passed to a function call expression.
public struct ArgumentsList: Sendable {
	/// An argument passed to a function call expression.
	public struct Argument: Sendable {
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

	/// The arguments in the list.
	public let arguments: [Argument]

	/// Creates a list of parameters.
	///
	/// - Parameter arguments: The arguments in the list.
	public init(_ arguments: [Argument] = []) {
		self.arguments = arguments
	}

	/// Creates a list of parameters.
	///
	/// - Parameter arguments: The arguments in the list.
	public init(@ArrayBuilder<Argument> _ arguments: () -> [Argument]) {
		self.arguments = arguments()
	}
}

extension ArgumentsList: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Argument...) {
		self.arguments = elements
	}
}

extension ArgumentsList: RandomAccessCollection {
	public var startIndex: Int {
		arguments.startIndex
	}

	public var endIndex: Int {
		arguments.endIndex
	}

	public subscript(position: Int) -> Argument {
		arguments[position]
	}
}

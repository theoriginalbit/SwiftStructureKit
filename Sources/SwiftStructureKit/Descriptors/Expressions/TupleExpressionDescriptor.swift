//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public protocol TupleElementConvertible: Sendable {
	func asTupleElement() -> TupleExpressionDescriptor.TupleElement
}

extension ExpressionDescriptor: TupleElementConvertible {
	public func asTupleElement() -> TupleExpressionDescriptor.TupleElement {
		TupleExpressionDescriptor.TupleElement(self)
	}
}
extension TupleExpressionDescriptor.TupleElement: TupleElementConvertible {
	public func asTupleElement() -> TupleExpressionDescriptor.TupleElement {
		self
	}
}

public struct TupleExpressionDescriptor: Sendable {
	public struct TupleElement: Sendable {
		public let label: String?

		public let value: ExpressionDescriptor

		public init(label: String? = nil, _ value: ExpressionDescriptor) {
			self.label = label
			self.value = value
		}
	}

	public let elements: [TupleElement]

	public init() {
		self.elements = []
	}

	public init(_ element1: any TupleElementConvertible, _ element2: any TupleElementConvertible, _ elements: (any TupleElementConvertible)...) {
		self.elements = [element1.asTupleElement(), element2.asTupleElement()] + elements.map { $0.asTupleElement() }
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A list of elements with an array builder convenience.
public struct List<Element: Sendable>: Sendable {
	/// The elements in the list.
	public let elements: [Element]

	/// A list of elements.
	///
	/// - Parameter elements: The elements in the list.
	public init(_ elements: [Element]) {
		self.elements = elements
	}

	/// Creates a list of elements.
	///
	/// - Parameter elements: The elements in the list.
	public init(@ArrayBuilder<Element> _ elements: () -> [Element]) {
		self.elements = elements()
	}
}

extension List: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
}

extension List: RandomAccessCollection {
	public var startIndex: Int {
		elements.startIndex
	}

	public var endIndex: Int {
		elements.endIndex
	}

	public subscript(position: Int) -> Element {
		elements[position]
	}
}

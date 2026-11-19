//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public struct NonEmptyList<Element: Sendable>: Sendable {
	public let elements: [Element]

	public init(_ element: Element, _ elements: Element...) {
		self.elements = CollectionOfOne(element) + elements
	}

	public init(@NonEmptyListBuilder<Element> _ elements: () -> Self) {
		self = elements()
	}

	init(_unchecked elements: [Element]) {
		self.elements = elements
	}
}

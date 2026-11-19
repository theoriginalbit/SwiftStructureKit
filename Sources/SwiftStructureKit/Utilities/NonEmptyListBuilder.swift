//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

@resultBuilder
public enum NonEmptyListBuilder<Element: Sendable> {
	public typealias Result = [Element]

	public static func buildExpression(_ expression: ()) -> Result {
		[]
	}

	public static func buildExpression(_ expression: Element) -> Result {
		[expression]
	}

	public static func buildPartialBlock(first: Result) -> Result {
		first
	}

	public static func buildPartialBlock(accumulated: Result, next: Result) -> Result {
		accumulated + next
	}

	public static func buildArray(_ components: Result) -> Result {
		components
	}

	public static func buildArray(_ components: [Result]) -> Result {
		Array(components.joined())
	}

	public static func buildOptional(_ component: Result?) -> Result {
		component ?? []
	}

	public static func buildEither(first component: Result) -> Result {
		component
	}

	public static func buildEither(second component: Result) -> Result {
		component
	}

	public static func buildLimitedAvailability(_ component: Result) -> Result {
		component
	}

	public static func buildFinalResult(_ components: [Element]) -> NonEmptyList<Element> {
		NonEmptyList(_unchecked: components)
	}

	@available(*, unavailable, message: "Content must contain at least one element")
	public static func buildBlock() -> [Element] {
		[]
	}
}

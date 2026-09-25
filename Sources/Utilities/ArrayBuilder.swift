//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

@resultBuilder
public enum ArrayBuilder<T> {
	public static func buildBlock(_ components: [T]...) -> [T] {
		Array(components.joined())
	}

	public static func buildOptional(_ component: [T]?) -> [T] {
		component ?? []
	}

	public static func buildEither(first component: [T]) -> [T] {
		component
	}

	public static func buildEither(second component: [T]) -> [T] {
		component
	}

	public static func buildArray(_ components: [[T]]) -> [T] {
		Array(components.joined())
	}

	public static func buildExpression(_ statement: T) -> [T] {
		[statement]
	}

	public static func buildLimitedAvailability(_ component: [T]) -> [T] {
		component
	}
}

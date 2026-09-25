//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

@resultBuilder
public enum ArrayBuilder<T> {
	public typealias Result = [T]

	public static func buildBlock(_ components: Result...) -> Result {
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

	public static func buildArray(_ components: [Result]) -> Result {
		Array(components.joined())
	}

	public static func buildExpression(_ statement: T) -> Result {
		[statement]
	}

	public static func buildLimitedAvailability(_ component: Result) -> Result {
		component
	}
}

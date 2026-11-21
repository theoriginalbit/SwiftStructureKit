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

	public static func buildArray(_ components: Result) -> Result {
		components
	}

	public static func buildArray(_ components: [Result]) -> Result {
		Array(components.joined())
	}

	/// Allows function calls to logging or diagnostics in builders
	public static func buildExpression(_: ()) -> Result {
		[]
	}

	public static func buildExpression(_ expression: Result) -> Result {
		expression
	}

	public static func buildExpression(_ expression: T) -> Result {
		[expression]
	}

	public static func buildExpression(_ expression: T?) -> Result {
		if let expression {
			return [expression]
		}
		return []
	}

	public static func buildLimitedAvailability(_ component: Result) -> Result {
		component
	}
}

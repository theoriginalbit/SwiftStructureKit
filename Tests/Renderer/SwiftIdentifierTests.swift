//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct SwiftIdentifierTests {
	@Test("Sanitize Swift identifiers defensively", arguments: [
		("$nake…", "_dollar_nake_x2026_"),
		("9-$patch", "_9_hyphen__dollar_patch"),
		("$0", "_dollar_0"),
		("class", "`class`"),
		("`typealias`", "`typealias`"),
		("``", "``"),
		("", "_empty"),
		("_", "_"),
		("café", "café"),
		("snake_case_9", "snake_case_9"),
	])
	func sanitizeSwiftDeclarationIdentifiers(input: String, expected: String) {
		#expect(SwiftIdentifier.sanitized(input) == expected)
	}

	private typealias IOArgs = Array<(String, SwiftIdentifier.Position, String)>

	@Test("Escape keywords according to syntactic position", arguments: IOArgs([
		("default", .declaration, "`default`"),
		("Any", .declaration, "`Any`"),
		("self", .declaration, "`self`"),
		("init", .declaration, "`init`"),
		("default", .reference, "`default`"),
		("self", .reference, "self"),
		("Self", .reference, "Self"),
		("super", .reference, "super"),
		("Any", .reference, "Any"),
		("init", .reference, "init"),
		("default", .memberAccess, "default"),
		("init", .memberAccess, "init"),
		("default", .type, "`default`"),
		("Self", .type, "Self"),
		("default", .nestedType, "default"),
		("for", .argumentLabel, "for"),
		("inout", .argumentLabel, "`inout`"),
		("var", .argumentLabel, "`var`"),
		("let", .argumentLabel, "`let`"),
		("in", .documentation, "in"),
		("9-x", .documentation, "_9_hyphen_x"),
	]))
	func escapeByPosition(input: String, position: SwiftIdentifier.Position, expected: String) {
		#expect(SwiftIdentifier.sanitized(input, position: position) == expected)
	}

	@Test("A leading $ is allowed only where projected values can be referenced", arguments: IOArgs([
		("$binding", .reference, "$binding"),
		("$binding", .memberAccess, "$binding"),
		("$0", .reference, "$0"),
		("$12", .reference, "$12"),
		("$default", .reference, "$default"),
		("$bad-name", .reference, "$bad_hyphen_name"),
		("$", .reference, "_dollar_"),
		("$binding", .declaration, "_dollar_binding"),
		("$binding", .argumentLabel, "_dollar_binding"),
		("$Response", .type, "_dollar_Response"),
		("$Response", .nestedType, "_dollar_Response"),
		("$0", .declaration, "_dollar_0"),
	]))
	func dollarPrefixByPosition(input: String, position: SwiftIdentifier.Position, expected: String) {
		#expect(SwiftIdentifier.sanitized(input, position: position) == expected)
	}
}

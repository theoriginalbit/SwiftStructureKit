//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

enum RenderTest {
	static func render(indentUsing style: CodeIndentStyle = .spaces(4), _ block: (inout CodeWriter) -> Void) -> String {
		var writer = CodeWriter(indentUsing: style)
		block(&writer)
		return String(decoding: writer.rendered(), as: UTF8.self)
	}
}

/// Asserts that rendered output matches `expected`.
///
/// Unlike a plain `#expect(actual == expected)`, a failure reports a line-based diff with
/// whitespace made visible, which is what you need when two multi-line blobs differ by a
/// single space or blank line.
func expectRendered(
	_ actual: String,
	matches expected: String,
	sourceLocation: SourceLocation = #_sourceLocation,
) {
	ReferenceTest.assert(actual, matches: expected, sourceLocation: sourceLocation)
}

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

	static func renderLine(indentUsing style: CodeIndentStyle = .tabs, _ block: (inout LineWriter) -> Void) -> String {
		let result = render(indentUsing: style) { writer in
			writer.writeLine { line in
				block(&line)
			}
		}
		return String(result.dropLast())
	}
}

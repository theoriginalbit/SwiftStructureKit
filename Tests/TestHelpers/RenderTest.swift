//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

enum RenderTest {
	static func render(_ block: (inout CodeWriter) -> Void) -> String {
		var writer = CodeWriter()
		block(&writer)
		return String(decoding: writer.rendered(), as: UTF8.self)
	}
}

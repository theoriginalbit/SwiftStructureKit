//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

enum RenderTest {
	static func render(_ block: (borrowing CodeRenderer) -> Void) -> String {
		let renderer = CodeRenderer()
		block(renderer)
		return String(decoding: renderer.finish(), as: UTF8.self)
	}
}

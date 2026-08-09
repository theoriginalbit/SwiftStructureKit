//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing
@testable import SwiftStructureKit

@Suite struct CodeIndentStyleTests {
	struct SpaceParam {
		let perLevel: UInt
		let renderedLevel: UInt
		let expectedCount: Int
	}

	@Test(
		"Spaces indent style appends correct number of space characters",
		arguments: [
			SpaceParam(perLevel: 2, renderedLevel: 0, expectedCount: 0),
			SpaceParam(perLevel: 4, renderedLevel: 0, expectedCount: 0),
			SpaceParam(perLevel: 2, renderedLevel: 1, expectedCount: 2),
			SpaceParam(perLevel: 3, renderedLevel: 1, expectedCount: 3),
			SpaceParam(perLevel: 2, renderedLevel: 3, expectedCount: 6),
			SpaceParam(perLevel: 4, renderedLevel: 2, expectedCount: 8),
		]
	)
	func spacesAppendsExpectedCount(_ spec: SpaceParam) {
		var buffer = Data()
		CodeIndentStyle.spaces(spec.perLevel).appendIndentation(for: spec.renderedLevel, to: &buffer)

		#expect(buffer.count == spec.expectedCount)
		let spaceChar = UInt8(ascii: " ")
		#expect(buffer.allSatisfy { $0 == spaceChar })
	}

	struct TabParam {
		let renderedLevel: UInt
		let expectedCount: Int
	}

	@Test(
		"Tabs style appends one tab per level",
		arguments: [
			TabParam(renderedLevel: UInt(0), expectedCount: 0),
			TabParam(renderedLevel: UInt(1), expectedCount: 1),
			TabParam(renderedLevel: UInt(4), expectedCount: 4),
		]
	)
	func tabsAppendsExpectedCount(_ spec: TabParam) {
		var buffer = Data()
		CodeIndentStyle.tabs.appendIndentation(for: spec.renderedLevel, to: &buffer)

		#expect(buffer.count == spec.expectedCount)
		let tabChar = UInt8(ascii: "\t")
		#expect(buffer.allSatisfy { $0 == tabChar })
	}

	@Test("Appends to existing buffer without clearing it")
	func appendsWithoutClearingExistingBuffer() {
		var buffer = Data([0x41]) // "A"
		CodeIndentStyle.spaces(2).appendIndentation(for: 1, to: &buffer)

		#expect(buffer == Data([0x41, 0x20, 0x20]))
	}
}

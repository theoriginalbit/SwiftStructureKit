//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration)) struct ArrayBuilderTests {
	@Test func buildsEmptyBlock() {
		#expect(makeArray {}.isEmpty)
	}

	@Test func buildsExpressionsAndBlocks() {
		let values = makeArray {
			1
			2
			3
		}

		#expect(values == [1, 2, 3])
	}

	@Test func buildsOptionalComponents() {
		let included = true
		let excluded = false

		let values = makeArray {
			if included {
				1
				2
			}
			if excluded {
				3
			}
			4
		}

		#expect(values == [1, 2, 4])
	}

	@Test func buildsEitherBranch() {
		let condition = false

		let values = makeArray {
			if condition {
				1
			} else {
				2
				3
			}
		}

		#expect(values == [2, 3])
	}

	@Test func buildsArrayComponents() {
		let values = makeArray {
			for value in 1...3 {
				value
				value * 10
			}
		}

		#expect(values == [1, 10, 2, 20, 3, 30])
	}

	private func makeArray(
		@ArrayBuilder<Int> _ content: () -> [Int]
	) -> [Int] {
		content()
	}
}

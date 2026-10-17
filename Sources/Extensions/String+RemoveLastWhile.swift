//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

extension String {
	mutating func removingLast(while precondition: (Character) -> Bool) {
		while let last = self.last, precondition(last) {
			removeLast()
		}
	}

	func removeLast(while precondition: (Character) -> Bool) -> Self {
		var result = self
		while let last = result.last, precondition(last) {
			result.removeLast()
		}
		return result
	}
}

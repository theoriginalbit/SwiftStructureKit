//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

extension Data {
	mutating func append(repeating byte: UInt8, count: Int) {
		guard count > 0 else { return }
		append(contentsOf: repeatElement(byte, count: count))
	}
}

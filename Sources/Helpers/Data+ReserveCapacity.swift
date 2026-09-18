//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

extension Data {
	init(reserveCapacity size: Int) {
		self.init()
		reserveCapacity(size)
	}
}

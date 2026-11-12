//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public extension Array {
	init(@ArrayBuilder<Element> _ build: () -> [Element]) {
		self = build()
	}
}

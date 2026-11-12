//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension Sequence where Element: Hashable {
	func removingDuplicates() -> [Element] {
		var seen = Set<Element>()
		return filter { seen.insert($0).inserted }
	}
}

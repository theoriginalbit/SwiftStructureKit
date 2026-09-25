//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration)) struct EffectSpecifiersTests {
	@Test func cannotCreateInvalidEffects() async throws {
		let result = try await #require(processExitsWith: .signal(SIGTRAP), observing: [\.standardErrorContent]) {
			_ = EffectSpecifiers()
		}
		let stderr = String(decoding: result.standardErrorContent, as: UTF8.self)
		#expect(stderr.contains("Effect requires at least one of `async` or a throwing specifier"))
	}
}

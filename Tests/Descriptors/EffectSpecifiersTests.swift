//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration)) struct EffectSpecifiersTests {
	@Test func emptyEffects() {
		let effects = EffectSpecifiers()

		#expect(effects.hasEffects == false)
		#expect(EffectSpecifiers.none.hasEffects == false)
	}

	@Test(
		arguments: [
			EffectSpecifiers(isAsync: true),
			EffectSpecifiers(throwingSpecifier: .throws),
			EffectSpecifiers(isAsync: true, throwingSpecifier: .throws),
		]
	)
	func nonemptyEffects(effects: EffectSpecifiers) {
		#expect(effects.hasEffects == true)
	}
}

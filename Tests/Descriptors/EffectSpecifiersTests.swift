//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration)) struct EffectSpecifiersTests {
	@Test func emptyEffects() {
		let effects = EffectSpecifiers<FunctionThrowingSpecifier>()

		#expect(effects.hasEffects == false)
		#expect(EffectSpecifiers<FunctionThrowingSpecifier>.none.hasEffects == false)
	}

	@Test(
		arguments: [
			EffectSpecifiers<FunctionThrowingSpecifier>(isAsync: true),
			EffectSpecifiers<FunctionThrowingSpecifier>(throwingSpecifier: .throws),
			EffectSpecifiers<FunctionThrowingSpecifier>(isAsync: true, throwingSpecifier: .throws),
		]
	)
	func nonemptyEffects(effects: EffectSpecifiers<FunctionThrowingSpecifier>) {
		#expect(effects.hasEffects == true)
	}

	@Test func closureAndPropertyEffects() {
		#expect(EffectSpecifiers<ThrowingSpecifier>.none.hasEffects == false)
		#expect(EffectSpecifiers<ThrowingSpecifier>.async.hasEffects == true)
		#expect(EffectSpecifiers<ThrowingSpecifier>.throws.hasEffects == true)
		#expect(EffectSpecifiers<ThrowingSpecifier>.throws(.identifier("ReadError")).hasEffects == true)
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation
import Testing
@testable import SwiftStructureKit

@Suite(.tags(.declaration)) struct EffectSpecifiersTests {
	@Test(arguments: [
		EffectSpecifiers<FunctionThrowingSpecifier>(),
		EffectSpecifiers<FunctionThrowingSpecifier>.none
	]) func emptyFunctionEffects(effects: EffectSpecifiers<FunctionThrowingSpecifier>) {
		#expect(effects.hasEffects == false)
	}

	@Test(arguments: [
		EffectSpecifiers<FunctionThrowingSpecifier>(isAsync: true),
		EffectSpecifiers<FunctionThrowingSpecifier>(throwingSpecifier: .throws),
		EffectSpecifiers<FunctionThrowingSpecifier>(isAsync: true, throwingSpecifier: .throws),
		EffectSpecifiers<FunctionThrowingSpecifier>(throwingSpecifier: .rethrows),
		EffectSpecifiers<FunctionThrowingSpecifier>(isAsync: true, throwingSpecifier: .rethrows),
		EffectSpecifiers<FunctionThrowingSpecifier>.throws(.identifier("ReadError"))
	]) func nonemptyFunctionEffects(effects: EffectSpecifiers<FunctionThrowingSpecifier>) {
		#expect(effects.hasEffects == true)
	}

	@Test(arguments: [
		EffectSpecifiers<ThrowingSpecifier>(),
		EffectSpecifiers<ThrowingSpecifier>.none
	]) func emptyClosureAndPropertyEffects(effects: EffectSpecifiers<ThrowingSpecifier>) {
		#expect(effects.hasEffects == false)
	}

	@Test(arguments: [
		EffectSpecifiers<ThrowingSpecifier>(isAsync: true),
		EffectSpecifiers<ThrowingSpecifier>(throwingSpecifier: .throws),
		EffectSpecifiers<ThrowingSpecifier>(isAsync: true, throwingSpecifier: .throws),
		EffectSpecifiers<ThrowingSpecifier>.throws(.identifier("ReadError"))
	]) func nonemptyClosureAndPropertyEffects(effects: EffectSpecifiers<ThrowingSpecifier>) {
		#expect(effects.hasEffects == true)
	}
}

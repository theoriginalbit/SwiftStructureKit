//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

struct TokenWriter: ~Copyable {
	private static let space = " "

	private var buffer = ""

	/// The content most recently written on this line accepts a space after it. A space is
	/// only written when the following content accepts one before it as well.
	private var previousAcceptedSpaceAfter = false

	mutating func write(_ value: String, acceptsSpaceBefore: Bool = true, acceptsSpaceAfter: Bool = true) {
		guard !value.isEmpty else { return }
		if previousAcceptedSpaceAfter && acceptsSpaceBefore {
			// both writes were happy to add spacing
			buffer += Self.space
		}
		buffer += value
		previousAcceptedSpaceAfter = acceptsSpaceAfter
	}

	mutating func write(_ punctuation: Punctuation) {
		write(
			punctuation.text,
			acceptsSpaceBefore: punctuation.acceptsSpaceBefore,
			acceptsSpaceAfter: punctuation.acceptsSpaceAfter
		)
	}

	consuming func finish() -> String {
		buffer
	}

	static func render(_ work: (inout Self) -> Void) -> String {
		var writer = Self()
		work(&writer)
		return writer.finish()
	}
}

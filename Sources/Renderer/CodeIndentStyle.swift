//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

/// The indentation characters and width used when rendering Swift source.
public enum CodeIndentStyle: Sendable {
	/// Indents each level with the specified number of spaces.
	case spaces(UInt)

	/// Indents each level with one tab character.
	case tabs

	private static let space = UInt8(ascii: " ")
	private static let tab = UInt8(ascii: "\t")

	func appendIndentation(for level: UInt, to buffer: inout Data) {
		switch self {
		case let .spaces(count):
			buffer.append(
				repeating: Self.space,
				count: Int(count * level)
			)
		case .tabs:
			buffer.append(
				repeating: Self.tab,
				count: Int(level)
			)
		}
	}
}

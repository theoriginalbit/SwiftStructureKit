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
}

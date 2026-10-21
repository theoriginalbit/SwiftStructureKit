//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A punctuation mark and how it is spaced relative to its neighbours on a line.
///
/// Spacing will only be added when two neighbours both accept one on their neighbours edge.
struct Punctuation: Equatable {
	/// The punctuation mark.
	let text: String

	/// Whether a space may separate the mark from preceding content that also accepts one.
	let acceptsSpaceBefore: Bool

	/// Whether a space may separate the mark from following content that also accepts one.
	let acceptsSpaceAfter: Bool

	private init(_ text: String, acceptsSpaceBefore: Bool, acceptsSpaceAfter: Bool) {
		self.text = text
		self.acceptsSpaceBefore = acceptsSpaceBefore
		self.acceptsSpaceAfter = acceptsSpaceAfter
	}

	/// The `(` punctuation mark.
	static let leftParen = Self("(", acceptsSpaceBefore: false, acceptsSpaceAfter: false)

	/// The `)` punctuation mark.
	static let rightParen = Self(")", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

	/// The `<` punctuation mark.
	static let leftAngle = Self("<", acceptsSpaceBefore: false, acceptsSpaceAfter: false)

	/// The `>` punctuation mark.
	static let rightAngle = Self(">", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

	/// The `{` punctuation mark.
	static let leftBrace = Self("{", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `}` punctuation mark.
	static let rightBrace = Self("}", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `[` punctuation mark.
	static let leftBracket = Self("[", acceptsSpaceBefore: true, acceptsSpaceAfter: false)

	/// The `]` punctuation mark.
	static let rightBracket = Self("]", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

	/// The `:` punctuation mark.
	static let colon = Self(":", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

	/// The `,` punctuation mark.
	static let comma = Self(",", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

	/// The `&` punctuation mark.
	static let ampersand = Self("&", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `.` punctuation mark.
	static let period = Self(".", acceptsSpaceBefore: false, acceptsSpaceAfter: false)

	/// The `=` punctuation mark.
	static let equal = Self("=", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `==` punctuation mark.
	static let equality = Self("==", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `->` punctuation mark.
	static let arrow = Self("->", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `?` punctuation mark.
	static let questionMark = Self("?", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

	/// The `#` punctuation mark.
	static let pound = Self("#", acceptsSpaceBefore: false, acceptsSpaceAfter: false)
}

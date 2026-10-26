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

	/// The `.` punctuation mark.
	static let period = Self(".", acceptsSpaceBefore: false, acceptsSpaceAfter: false)

	/// The `=` punctuation mark.
	static let assign = Self("=", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `==` punctuation mark.
	static let equals = Self("==", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `->` punctuation mark.
	static let arrow = Self("->", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `-` punctuation mark.
	static let minus = Self("-", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// Punctuation that is used as a token prefix. They may exist in ``Punctuation`` with different spacing rules.
	enum Prefix {
		/// The `&` punctuation mark.
		static let ampersand = Punctuation("&", acceptsSpaceBefore: true, acceptsSpaceAfter: false)

		/// The `#` punctuation mark.
		static let pound = Punctuation("#", acceptsSpaceBefore: false, acceptsSpaceAfter: false)

		/// The `.` punctuation mark that allows space before it unlike ``Punctuation/period``.
		static let period = Punctuation(".", acceptsSpaceBefore: true, acceptsSpaceAfter: false)

		/// The `-` punctuation mark. Prefixed for negative numbers.
		///
		/// Example output: `-4`. ``Punctuation/minus`` would output as invalid `- 4`.
		static let minus = Punctuation("-", acceptsSpaceBefore: true, acceptsSpaceAfter: false)

		/// The `(` punctuation mark. Prefixed so as to allow a leading space.
		///
		/// Example output: `let x = (value ?? 0)`. ``Punctuation/leftParen`` would
		/// output as `let x =(value ?? 0)`.
		static let leftParen = Punctuation("(", acceptsSpaceBefore: true, acceptsSpaceAfter: false)
	}

	/// Punctuation that is used as a token postfix. They may exist in ``Punctuation`` with different spacing rules.
	enum Postfix {
		/// The `?` punctuation mark.
		static let questionMark = Punctuation("?", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

		/// The `!` punctuation mark.
		static let exclamationMark = Punctuation("!", acceptsSpaceBefore: false, acceptsSpaceAfter: true)
	}

	/// Punctuation that is used as an operator such as bitwise or boolean logic. Typically an infix between two tokens and allows for
	/// spacing on both sides.
	///
	/// The value may exist in ``Punctuation`` with a different name and/or spacing rules.
	enum Operator {
		static let bitwiseAnd = Punctuation("&", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

		static let nilCoalescing = Punctuation("??", acceptsSpaceBefore: true, acceptsSpaceAfter: true)
	}
}
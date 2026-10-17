//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

/// Accumulates rendered Swift source one line at a time.
///
/// The writer tracks its position on the current physical line. Callers are provided minimal control over emitting
/// whitespace because:
///
/// - Indentation is emitted when the first content of a line is written;
/// - the space between two neighbouring pieces of content is decided by the pieces themselves (see ``LineWriter``);
/// - brace-delimited blocks are opened and closed by ``LineWriter/block(_:)``; and
/// - punctuation influences content spacing.
struct CodeWriter: ~Copyable {
	private static let newLine = UInt8(ascii: "\n")
	private static let space = UInt8(ascii: " ")
	private static let tab = UInt8(ascii: "\t")

	private var buffer: Data

	private var indentLevel: UInt = 0

	let indentStyle: CodeIndentStyle

	/// Nothing has been written on the current physical line yet, so the next content is
	/// preceded by indentation rather than a separator.
	private var isAtLineStart = true

	/// The content most recently written on this line accepts a space after it. A space is
	/// only written when the following content accepts one before it as well.
	private var acceptsSpaceAfter = false

	/// A block has been opened but its first line has not started. The line break after the
	/// `{` is deferred until that line begins, so a block that is never written to closes on
	/// the opening line as `{}`.
	private var hasPendingLineBreak = false

	init(estimatedFinalSizeInBytes size: Int = 12 * 1024 /* 12 KB */, indentUsing style: CodeIndentStyle) {
		// eagerly pre-allocate to minimise impacts of resizing
		buffer = Data(reserveCapacity: size)
		indentStyle = style
	}

	// MARK: Indentation

	mutating func indented(_ work: (_ writer: inout Self) -> Void) {
		indentLevel += 1
		defer { indentLevel -= 1 }
		work(&self)
	}

	mutating func indented(to level: UInt, _ work: (inout Self) -> Void) {
		let previousIndentLevel = indentLevel
		indentLevel = level
		defer { indentLevel = previousIndentLevel }
		work(&self)
	}

	// MARK: Lines

	/// Writes an empty line
	mutating func writeBlankLine() {
		beginLine()
		breakLine()
	}

	/// Renders each element in turn, writing a blank line between consecutive elements.
	mutating func writeSeparated<Element>(
		_ elements: some Collection<Element>,
		_ render: (Element, inout Self) -> Void
	) {
		for (index, element) in elements.enumerated() {
			if index > 0 {
				writeBlankLine()
			}
			render(element, &self)
		}
	}

	/// Writes `text` as one or more physical lines, each indented and prefixed the same way.
	///
	/// A physical line that is empty is written with the prefix's trailing whitespace trimmed and
	/// with no indentation at all when the prefix is empty, so the output never contains trailing
	/// whitespace.
	mutating func writeLine(_ text: String, prefix: String = "", indent: Bool = true) {
		// pre-process in case multiple lines are written
		let trimmedPrefix = prefix.removeLast(while: \.isWhitespace).utf8
		let prefix = prefix.utf8

		var remaining = text.utf8[...]
		while true {
			let nextNewLineIndex = remaining.firstIndex(of: Self.newLine)
			let lineContent = remaining[..<(nextNewLineIndex ?? remaining.endIndex)]

			beginLine()
			if lineContent.isEmpty {
				if !trimmedPrefix.isEmpty {
					if indent {
						appendIndentation()
					}
					buffer.append(contentsOf: trimmedPrefix)
				}
			} else {
				if indent {
					appendIndentation()
				}
				buffer.append(contentsOf: prefix)
				buffer.append(contentsOf: lineContent)
			}
			breakLine()

			guard let nextNewLineIndex else { break /* all text was processed */ }
			remaining = remaining[remaining.index(after: nextNewLineIndex)...]
		}
	}

	/// Writes a single logical line whose content is produced by `work`.
	///
	/// The line may span several physical lines when it contains a multi-line token or a
	/// ``LineWriter/block(_:)``; it is terminated once `work` returns.
	mutating func writeLine(_ work: (_ line: inout LineWriter) -> Void) {
		beginLine()
		var line = LineWriter(consume self)
		work(&line)
		self = line.finish()
		breakLine()
	}

	consuming func rendered() -> Data {
		buffer
	}

	// MARK: LineWriter Contract

	/// Writes `punctuation` on the current line.
	fileprivate mutating func writePunctuation(_ punctuation: Punctuation) {
		writeContent(
			punctuation.text.utf8,
			acceptsSpaceBefore: punctuation.acceptsSpaceBefore,
			acceptsSpaceAfter: punctuation.acceptsSpaceAfter
		)
	}

	/// Writes `bytes` on the current line, separating them from the preceding content with a
	/// space when both sides accept one. Each embedded newline ends the physical line and the
	/// continuation is indented to the current level.
	fileprivate mutating func writeContent(
		_ bytes: some BidirectionalCollection<UInt8>,
		acceptsSpaceBefore: Bool,
		acceptsSpaceAfter: Bool
	) {
		assert(!hasPendingLineBreak, "Line content can only be written from within a line")
		guard !bytes.isEmpty else { return }

		var remaining = bytes[...]
		while let newLineIndex = remaining.firstIndex(of: Self.newLine) {
			writeSegment(remaining[..<newLineIndex], acceptsSpaceBefore: acceptsSpaceBefore)
			breakLine()
			remaining = remaining[remaining.index(after: newLineIndex)...]
		}
		writeSegment(remaining, acceptsSpaceBefore: acceptsSpaceBefore)
		self.acceptsSpaceAfter = acceptsSpaceAfter
	}

	/// Opens a block on the current line. The block's lines are indented one level deeper
	/// and the line break that follows the `{` is deferred until the first of them begins.
	fileprivate mutating func beginBlock() {
		writePunctuation(.leftBrace)
		hasPendingLineBreak = true
		indentLevel += 1
	}

	/// Closes the block opened by the matching ``beginBlock()``. The closing brace shares
	/// the opening line when the block is empty and otherwise starts a line of its own at
	/// the enclosing indentation. Either way the line continues after it.
	fileprivate mutating func endBlock() {
		indentLevel -= 1
		if hasPendingLineBreak {
			// Nothing was written inside the block, so it closes as `{}`.
			hasPendingLineBreak = false
			acceptsSpaceAfter = false
		} else {
			assert(isAtLineStart, "A block body must end at the start of a line")
		}
		writePunctuation(.rightBrace)
	}

	// MARK: Helpers

	/// Prepares to start a new line, ending the opening line of an enclosing block if this is the block's first line.
	private mutating func beginLine() {
		assert(isAtLineStart || hasPendingLineBreak, "A line cannot start part-way through another line")
		if hasPendingLineBreak {
			hasPendingLineBreak = false
			breakLine()
		}
	}

	private mutating func breakLine() {
		buffer.append(Self.newLine)
		isAtLineStart = true
		acceptsSpaceAfter = false // needs indentation, not token spacing
	}

	private mutating func writeSegment(_ segment: some Collection<UInt8>, acceptsSpaceBefore: Bool) {
		guard !segment.isEmpty else { return }

		if isAtLineStart {
			appendIndentation()
			isAtLineStart = false
		} else if acceptsSpaceAfter && acceptsSpaceBefore {
			// both segments were happy to add spacing
			buffer.append(Self.space)
		}

		// Append stripping carriage returns
		buffer.append(contentsOf: segment)
	}

	private mutating func appendIndentation() {
		switch indentStyle {
		case let .spaces(count):
			buffer.append(
				repeating: Self.space,
				count: Int(count * indentLevel)
			)
		case .tabs:
			buffer.append(
				repeating: Self.tab,
				count: Int(indentLevel)
			)
		}
	}
}

/// Writes the content of a single logical line of source.
///
/// Each piece of content declares whether it accepts a space on either side, and a space is
/// written between two neighbours only when both accept a space on their neighbours edge.
/// Punctuation defines their spacing rules.
///
/// Callers therefore describe *what* is on the line and never its whitespace.
struct LineWriter: ~Copyable {
	private var writer: CodeWriter

	fileprivate init(_ writer: consuming CodeWriter) {
		self.writer = writer
	}

	/// Writes a keyword, identifier, operator or rendered expression. Tokens are separated
	/// from neighbouring tokens by a single space.
	///
	/// Embedded newlines are preserved and each continuation line is indented to the current
	/// level, so a multi-line raw expressions will keep their structure.
	mutating func token(_ value: String) {
		writer.writeContent(value.utf8, acceptsSpaceBefore: true, acceptsSpaceAfter: true)
	}

	/// Writes a punctuation mark.
	mutating func punctuation(_ punctuation: Punctuation) {
		writer.writePunctuation(punctuation)
	}

	/// Writes a brace-delimited block whose lines are produced by `body`.
	///
	/// The opening brace is written on the current line. The body's lines are indented one
	/// level deeper and the closing brace is placed on a line of its own at the enclosing
	/// indentation, or directly after the opening brace when the body writes nothing. The
	/// current line resumes after the closing brace, so content that follows a block, such
	/// as `else` or a chained member access, is written as if the block were a single token.
	mutating func block(_ body: (_ writer: inout CodeWriter) -> Void) {
		writer.beginBlock()
		body(&writer)
		writer.endBlock()
	}

	/// Writes a ``CodeBlockDescriptor``'s statements as a brace-delimited block on the current line.
	mutating func block(_ body: CodeBlockDescriptor) {
		block { writer in
			StatementRenderer.render(body.statements, to: &writer)
		}
	}

	fileprivate consuming func finish() -> CodeWriter {
		writer
	}
}

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

	/// The `:` punctuation mark.
	static let colon = Self(":", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

	/// The `,` punctuation mark.
	static let comma = Self(",", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

	/// The `.` punctuation mark.
	static let period = Self(".", acceptsSpaceBefore: false, acceptsSpaceAfter: false)

	/// The `=` punctuation mark.
	static let equal = Self("=", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `->` punctuation mark.
	static let arrow = Self("->", acceptsSpaceBefore: true, acceptsSpaceAfter: true)

	/// The `?` punctuation mark.
	static let questionMark = Self("?", acceptsSpaceBefore: false, acceptsSpaceAfter: true)

	/// The `#` punctuation mark.
	static let pound = Self("#", acceptsSpaceBefore: false, acceptsSpaceAfter: false)
}

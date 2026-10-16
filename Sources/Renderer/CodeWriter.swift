//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

struct CodeWriter: ~Copyable {
	private static let newLine = UInt8(ascii: "\n")
	private static let carriageReturn = UInt8(ascii: "\r")

	private var buffer: Data

	private var indentLevel: UInt = 0

	let indentStyle: CodeIndentStyle

	init(estimatedFinalSizeInBytes size: Int = 12 * 1024 /* 12 KB */, indentUsing style: CodeIndentStyle = .spaces(4)) {
		// eagerly pre-allocate to minimise impacts of resizing
		buffer = Data(reserveCapacity: size)
		indentStyle = style
	}

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

	mutating func writeNewLine() {
		buffer.append(Self.newLine)
	}

	func isLastByteNewLine() -> Bool {
		buffer.last == Self.newLine
	}

	mutating func writeLine(
		_ line: String,
		prefix: String = "",
		indent: Bool = true
	) {
		_writeLine(line.utf8, prefix: prefix.utf8, indent: indent)
	}

	mutating func writeLine(
		prefix: String = "",
		_ work: (_ line: inout LineWriter) -> Void
	) {
		var lineWriter = LineWriter()
		work(&lineWriter)
		let line = lineWriter.finish()
		_writeLine(line, prefix: prefix.utf8)
	}

	private mutating func _writeLine(
		_ bytes: some Collection<UInt8>,
		prefix: some Collection<UInt8>,
		indent: Bool = true
	) {
		func writeStartOfLine() {
			if indent {
				indentStyle.appendIndentation(
					for: indentLevel,
					to: &buffer
				)
			}
			buffer.append(contentsOf: prefix)
		}

		if bytes.isEmpty {
			// emit indentation and prefix if there were no bytes
			writeStartOfLine()
		} else {
			var atStartOfLine = true
			for byte in bytes {
				if atStartOfLine {
					writeStartOfLine()
					atStartOfLine = false
				}

				if byte == Self.carriageReturn {
					continue
				}

				buffer.append(byte)

				if byte == Self.newLine {
					atStartOfLine = true // new indentation required, maybe
				}
			}
		}

		// always emit a trailing newline
		writeNewLine()
	}

	consuming func rendered() -> Data {
		buffer
	}
}

struct LineWriter: ~Copyable {
	private var buffer: Data
	private var shouldSeparateNextToken = false

	fileprivate init(estimatedLineLength: Int = 180) {
		buffer = Data(reserveCapacity: estimatedLineLength)
	}

	mutating func token(_ value: String, separateFromNextToken separating: Bool = true) {
		if shouldSeparateNextToken {
			buffer.append(UInt8(ascii: " "))
		}
		// line writer should not respect newlines in the token
		let sanitised = value.filter { !$0.isNewline }.utf8
		buffer.append(contentsOf: sanitised)
		shouldSeparateNextToken = separating
	}

	/// Writes a punctuation mark
	mutating func punctuation(_ punctuation: Punctuation) {
		buffer.append(contentsOf: punctuation.text.utf8)
		shouldSeparateNextToken = false
	}

	mutating func space() {
		buffer.append(UInt8(ascii: " "))
		shouldSeparateNextToken = false
	}

	fileprivate consuming func finish() -> Data {
		buffer
	}
}

struct TokenWriter: ~Copyable {
	private var buffer = ""

	mutating func write(_ value: String) {
		buffer += value
	}

	mutating func space() {
		buffer += " "
	}

	consuming func finish() -> String {
		buffer
	}
}

/// A punctuation mark
struct Punctuation {
	let text: String

	private init(_ value: StringLiteralType) {
		text = value
	}

	/// The `(` punctuation mark.
	static let leftParen = Self("(")

	/// The `)` punctuation mark.
	static let rightParen = Self(")")

	/// The `<` punctuation mark.
	static let leftAngle = Self("<")

	/// The `>` punctuation mark.
	static let rightAngle = Self(">")

	/// The `{` punctuation mark.
	static let leftBrace = Self("{")

	/// The `}` punctuation mark.
	static let rightBrace = Self("}")

	/// The `:` punctuation mark.
	static let colon = Self(":")

	/// The `,` punctuation mark.
	static let comma = Self(",")

	/// The `.` punctuation mark.
	static let period = Self(".")

	/// The `=` punctuation mark.
	static let equal = Self("=")

	/// The `->` punctuation mark.
	static let arrow = Self("->")

	/// The `?` punctuation mark.
	static let questionMark = Self("?")

	/// The `#` punctuation mark.
	static let pound = Self("#")
}

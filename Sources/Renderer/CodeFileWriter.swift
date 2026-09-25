//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

struct CodeFileWriter: ~Copyable {
	private static let newLine = UInt8(ascii: "\n")
	private static let carriageReturn = UInt8(ascii: "\r")

	private var buffer: Data

	private var indentLevel: UInt = 0

	private let indentStyle: CodeIndentStyle

	init(estimatedFinalSizeInBytes size: Int = 12 * 1024 /* 12 KB */, indentUsing style: CodeIndentStyle = .spaces(4)) {
		// eagerly pre-allocate to minimise impacts of resizing
		buffer = Data(reserveCapacity: size)
		indentStyle = style
	}

	mutating func indented(_ work: (_ file: inout Self) -> Void) {
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
		buffer.append(contentsOf: value.utf8)
		shouldSeparateNextToken = separating
	}

	mutating func punctuation(_ value: Unicode.Scalar) {
		buffer.append(UInt8(ascii: value))
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

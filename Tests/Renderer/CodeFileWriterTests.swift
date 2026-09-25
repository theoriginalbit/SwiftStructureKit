import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct CodeFileWriterTests {
	@Test("Test all major functions of the writer")
	func wholeContract() async throws {
		var writer = CodeFileWriter()

		writer.writeLine("import Foundation")
		writer.writeNewLine()

		writer.writeLine { line in
			line.token("public")
			line.token("func")
			line.token("hello")
			line.punctuation("(")
			line.punctuation(")")
			line.space()
			line.punctuation("{")
		}

		writer.indented(to: 4) { writer in
			writer.writeLine(#"print("Hello, world 1!")"#)
		}

		writer.indented { writer in
			writer.writeLine("print(\"Hello, world 2!\")")
			writer.writeNewLine()

			writer.writeLine { line in
				line.token("func")
				line.token("hello")
				line.punctuation("(")
				line.punctuation(")")
				line.space()
				line.punctuation("{")
			}

			writer.indented { writer in
				writer.writeLine("print(\"Hello, world 3!\")")
				writer.writeLine("#if DEBUG", indent: false)
				writer.writeLine("print(\"Hello, world 4!\")")
				writer.writeLine("#endif", indent: false)
				writer.writeLine("print(\"Hello, world 5!\")")
				writer.writeLine(#"""
				print("Hello, world 6!")
				print("Hello, world 7!")
				"""#)
			}

			writer.writeLine("}")
		}

		writer.writeLine("}")

		let actual = writer.rendered()
		let expected = try Fixtures.url("CodeFileWriterTests_contract")
		try ReferenceTest.assert(actual, matches: expected)
	}

	// MARK: - Indents

	@Test("indent: false skips indentation even when indent level > 0")
	func skipsIndentationWhenRequested() {
		var writer = CodeFileWriter(indentUsing: .spaces(2))
		writer.indented { file in
			file.writeLine("no indent", indent: false)
		}
		#expect(String(decoding: writer.rendered(), as: UTF8.self) == "no indent\n")
	}

	@Test("indented(_:) restores the previous indent level after the closure returns")
	func indentedRestoresLevel() {
		var writer = CodeFileWriter(indentUsing: .spaces(2))
		writer.indented { file in
			file.writeLine("inner")
		}
		writer.writeLine("outer")
		#expect(String(decoding: writer.rendered(), as: UTF8.self) == "  inner\nouter\n")
	}

	@Test("indented(to:) sets an absolute level and restores the previous one afterward")
	func indentedToAbsoluteLevel() {
		var writer = CodeFileWriter(indentUsing: .spaces(2))
		writer.indented { file in            // level 1
			file.indented(to: 3) { inner in  // level 3
				inner.writeLine("deep")
			}
			file.writeLine("back to one")    // should be level 1 again, not 3
		}
		#expect(String(decoding: writer.rendered(), as: UTF8.self) == "      deep\n  back to one\n")
	}

	@Test("Nested indented(_:) calls accumulate indent level")
	func nestedIndentedAccumulates() {
		var writer = CodeFileWriter(indentUsing: .spaces(2))
		writer.indented { outer in
			outer.indented { inner in
				inner.writeLine("nested")
			}
		}
		#expect(String(decoding: writer.rendered(), as: UTF8.self) == "    nested\n")
	}

	// MARK: - Multiline strings

	@Test("A string with newlines gets indentation re-applied on each embedded line")
	func newlineContentIndentsEachLine() {
		var writer = CodeFileWriter(indentUsing: .spaces(2))
		writer.indented { file in
			file.writeLine("line one\nline two")
		}
		#expect(String(decoding: writer.rendered(), as: UTF8.self) == "  line one\n  line two\n")
	}

	@Test("A multi-line string gets indentation re-applied on each embedded line")
	func multilineContentIndentsEachLine() {
		var writer = CodeFileWriter(indentUsing: .spaces(2))
		writer.indented { file in
			file.writeLine("""
			line one
			line two
			""")
		}
		#expect(String(decoding: writer.rendered(), as: UTF8.self) == "  line one\n  line two\n")
	}
}

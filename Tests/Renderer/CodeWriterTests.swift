//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct CodeWriterTests {
	@Test("Test all major functions of the writer")
	func wholeContract() throws {
		var writer = CodeWriter(indentUsing: .spaces(4))

		writer.writeLine("import Foundation")
		writer.writeBlankLine()

		writer.writeLine { line in
			line.token("public")
			line.token("func")
			line.token("hello")
			line.punctuation(.leftParen)
			line.punctuation(.rightParen)
			line.block { writer in
				writer.indented(to: 4) { writer in
					writer.writeLine(#"print("Hello, world 1!")"#)
				}

				writer.writeLine("print(\"Hello, world 2!\")")
				writer.writeBlankLine()

				writer.writeLine { line in
					line.token("func")
					line.token("hello")
					line.punctuation(.leftParen)
					line.punctuation(.rightParen)
					line.block { writer in
						writer.writeLine("print(\"Hello, world 3!\")")
						writer.writeLine("#if DEBUG", indent: false)
						writer.writeLine("Only needed\nin debug", prefix: "// ")
						writer.writeLine("print(\"Hello, world 4!\")")
						writer.writeLine("#endif", indent: false)
						writer.writeLine("print(\"Hello, world 5!\")")
						writer.writeLine { line in
							line.token("let")
							line.token("closure")
							line.punctuation(.assign)
							line.token("{\n    print(\"Hello, world 6!\")\n}")
						}
						writer.writeLine(#"""
							print("Hello, world 7!")
							print("Hello, world 8!")
							"""#)
					}
				}
			}
		}

		let actual = writer.rendered()
		try ReferenceTest.assert(
			actual,
			matches: Fixtures.url("CodeFileWriterTests_contract")
		)
	}

	// MARK: - Indents

	@Test("indent: false skips indentation even when indent level > 0")
	func skipsIndentationWhenRequested() {
		var writer = CodeWriter(indentUsing: .spaces(2))
		writer.indented { file in
			file.writeLine("no indent", indent: false)
		}
		expectRendered(String(decoding: writer.rendered(), as: UTF8.self), equals: "no indent\n")
	}

	@Test("indented(_:) restores the previous indent level after the closure returns")
	func indentedRestoresLevel() {
		var writer = CodeWriter(indentUsing: .spaces(2))
		writer.indented { file in
			file.writeLine("inner")
		}
		writer.writeLine("outer")
		expectRendered(String(decoding: writer.rendered(), as: UTF8.self), equals: "  inner\nouter\n")
	}

	@Test("indented(to:) sets an absolute level and restores the previous one afterward")
	func indentedToAbsoluteLevel() {
		var writer = CodeWriter(indentUsing: .spaces(2))
		writer.indented { file in            // level 1
			file.indented(to: 3) { inner in  // level 3
				inner.writeLine("deep")
			}
			file.writeLine("back to one")    // should be level 1 again, not 3
		}
		expectRendered(String(decoding: writer.rendered(), as: UTF8.self), equals: "      deep\n  back to one\n")
	}

	@Test("Nested indented(_:) calls accumulate indent level")
	func nestedIndentedAccumulates() {
		var writer = CodeWriter(indentUsing: .spaces(2))
		writer.indented { outer in
			outer.indented { inner in
				inner.writeLine("nested")
			}
		}
		expectRendered(String(decoding: writer.rendered(), as: UTF8.self), equals: "    nested\n")
	}

	// MARK: - Multiline strings

	@Test("A string with newlines gets indentation re-applied on each embedded line")
	func newlineContentIndentsEachLine() {
		var writer = CodeWriter(indentUsing: .spaces(2))
		writer.indented { file in
			file.writeLine("line one\nline two")
		}
		expectRendered(String(decoding: writer.rendered(), as: UTF8.self), equals: "  line one\n  line two\n")
	}

	@Test("A multi-line string gets indentation re-applied on each embedded line")
	func multilineContentIndentsEachLine() {
		var writer = CodeWriter(indentUsing: .spaces(2))
		writer.indented { file in
			file.writeLine("""
			line one
			line two
			""")
		}
		expectRendered(String(decoding: writer.rendered(), as: UTF8.self), equals: "  line one\n  line two\n")
	}
}

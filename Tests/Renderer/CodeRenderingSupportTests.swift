//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct CodeRenderingSupportTests {
	@Test("Render inline comment")
	func renderInlineComment() {
		let descriptor = InlineCommentDescriptor("You were the Chosen One!\nIt was said that you would destroy the Sith, not join them!\nBring balance to the Force, not leave it in darkness!")
		let output = RenderTest.render { renderer in
			renderer.renderInlineComment(descriptor)
		}
		let expected = """
		// You were the Chosen One!
		// It was said that you would destroy the Sith, not join them!
		// Bring balance to the Force, not leave it in darkness!
		
		"""
		#expect(output == expected)
	}

	@Test("Render inline comment from multiline string")
	func renderInlineCommentFromMultilineString() {
		let descriptor = InlineCommentDescriptor("""
		I see through the lies of the Jedi.
		I do not fear the Dark Side as you do!
		I have brought peace, freedom, justice and security to my new empire!
		""")
		let output = RenderTest.render { renderer in
			renderer.renderInlineComment(descriptor)
		}
		let expected = """
		// I see through the lies of the Jedi.
		// I do not fear the Dark Side as you do!
		// I have brought peace, freedom, justice and security to my new empire!

		"""
		#expect(output == expected)
	}

	@Test("Render mark comment")
	func renderMarkComment() {
		let descriptor = MarkCommentDescriptor("It's over Anakin, \nI have the high ground")
		let output = RenderTest.render { renderer in
			renderer.renderMarkComment(descriptor)
		}
		#expect(output == "// MARK: It's over Anakin, I have the high ground\n")
	}

	@Test("Render mark comment with section break")
	func renderMarkCommentWithSectionBreak() {
		let descriptor = MarkCommentDescriptor("You were my brother, Anakin. \nI loved you!", sectionBreak: true)
		let output = RenderTest.render { renderer in
			renderer.renderMarkComment(descriptor)
		}
		#expect(output == "// MARK: - You were my brother, Anakin. I loved you!\n")
	}
}

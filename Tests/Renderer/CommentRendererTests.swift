//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Testing
@testable import SwiftStructureKit

@Suite(.tags(.renderer)) struct CommentRendererTests {
	@Test("Render inline comment")
	func renderInlineComment() {
		let descriptor = InlineCommentDescriptor("You were the Chosen One!\nIt was said that you would destroy the Sith, not join them!\nBring balance to the Force, not leave it in darkness!")
		let output = RenderTest.render { writer in
			CommentRenderer.renderInlineComment(descriptor, to: &writer)
		}
		let expected = """
		// You were the Chosen One!
		// It was said that you would destroy the Sith, not join them!
		// Bring balance to the Force, not leave it in darkness!
		
		"""
		expectRendered(output, equals: expected)
	}

	@Test("Render inline comment from multiline string")
	func renderInlineCommentFromMultilineString() {
		let descriptor = InlineCommentDescriptor("""
		I see through the lies of the Jedi.
		I do not fear the Dark Side as you do!
		I have brought peace, freedom, justice and security to my new empire!
		""")
		let output = RenderTest.render { writer in
			CommentRenderer.renderInlineComment(descriptor, to: &writer)
		}
		let expected = """
		// I see through the lies of the Jedi.
		// I do not fear the Dark Side as you do!
		// I have brought peace, freedom, justice and security to my new empire!

		"""
		expectRendered(output, equals: expected)
	}

	@Test("Render mark comment")
	func renderMarkComment() {
		let descriptor = MarkCommentDescriptor("It's over Anakin, \nI have the high ground")
		let output = RenderTest.render { writer in
			CommentRenderer.renderMarkComment(descriptor, to: &writer)
		}
		expectRendered(output, equals: "// MARK: It's over Anakin, \\nI have the high ground\n")
	}

	@Test("Render mark comment with section break")
	func renderMarkCommentWithSectionBreak() {
		let descriptor = MarkCommentDescriptor("You were my brother, Anakin. \nI loved you!", sectionBreak: true)
		let output = RenderTest.render { writer in
			CommentRenderer.renderMarkComment(descriptor, to: &writer)
		}
		expectRendered(output, equals: "// MARK: - You were my brother, Anakin. \\nI loved you!\n")
	}
}

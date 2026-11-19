//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum TopLevelCompilerControlRenderer {
	static func render(_ descriptor: TopLevelCompilerControlDescriptor, to writer: inout CodeWriter) {
		switch descriptor {
		case let .directive(descriptor):
			CompilerControlRenderer.render(descriptor, to: &writer)
		case let .conditional(descriptor):
			renderCompilerControlConditional(descriptor, to: &writer)
		}
	}

	private static func renderCompilerControlConditional(_ descriptor: TopLevelCompilerConditionalDescriptor, to writer: inout CodeWriter) {
		switch descriptor {
		case let .if(descriptor):
			renderCompilerControlIfConditional(descriptor.branches, to: &writer)
		case let .ifElse(descriptor):
			renderCompilerControlIfConditional(descriptor.branches, elseBody: descriptor.elseBody, to: &writer)
		}
	}

	private static func renderCompilerControlIfConditional(
		_ branches: [TopLevelCompilerConditionalIfDescriptor.Branch],
		elseBody: [TopLevelDeclarationDescriptor]? = nil,
		to writer: inout CodeWriter
	) {
		var iterator = branches.makeIterator()
		if let first = iterator.next() {
			renderCompilerControlIfConditional(
				"#if",
				condition: first.condition,
				declarations: first.body,
				to: &writer
			)

			while let next = iterator.next() {
				renderCompilerControlIfConditional(
					"#elseif",
					condition: next.condition,
					declarations: next.body,
					to: &writer
				)
			}

			if let elseBody {
				renderCompilerControlIfConditional(
					"#else",
					condition: nil,
					declarations: elseBody,
					to: &writer
				)
			}

			writer.indented(to: 0) { writer in
				writer.writeLine("#endif")
			}
		}
	}

	private static func renderCompilerControlIfConditional(
		_ keyword: String,
		condition: String?,
		declarations: [TopLevelDeclarationDescriptor],
		to writer: inout CodeWriter
	) {
		writer.indented(to: 0) { writer in
			if let condition {
				writer.writeLine { line in
					line.token(keyword)
					line.token(condition)
				}
			} else {
				writer.writeLine(keyword)
			}
		}
		SwiftFileRenderer.render(declarations, to: &writer)
	}
}

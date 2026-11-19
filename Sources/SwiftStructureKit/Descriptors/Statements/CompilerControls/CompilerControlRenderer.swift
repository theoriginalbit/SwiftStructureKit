//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum CompilerControlRenderer {
	static func render(_ descriptor: CompilerControlDescriptor, to writer: inout CodeWriter) {
		switch descriptor {
		case let .directive(descriptor):
			render(descriptor, to: &writer)
		case let .conditional(descriptor):
			renderCompilerControlConditional(descriptor, to: &writer)
		}
	}

	static func render(_ descriptor: DiagnosticDirectiveDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			line.punctuation(.Prefix.pound)
			switch descriptor.kind {
			case .warning: line.token("warning")
			case .error: line.token("error")
			}
			line.punctuation(.leftParen)
			CodeRenderingSupport.renderLiteral(.string(descriptor.message), into: &line)
			line.punctuation(.rightParen)
		}
	}

	private static func renderCompilerControlConditional(_ descriptor: CompilerConditionalStatementDescriptor, to writer: inout CodeWriter) {
		switch descriptor {
		case let .if(descriptor):
			renderCompilerControlIfConditional(descriptor.branches, to: &writer)
		case let .ifElse(descriptor):
			renderCompilerControlIfConditional(descriptor.branches, elseBody: descriptor.elseBody, to: &writer)
		}
	}

	private static func renderCompilerControlIfConditional(
		_ branches: [IfStatementDescriptor.Branch],
		elseBody: CodeBlockDescriptor? = nil,
		to writer: inout CodeWriter
	) {
		var iterator = branches.makeIterator()
		if let first = iterator.next() {
			renderCompilerControlIfConditional(
				"#if",
				condition: first.condition,
				statements: first.body.statements,
				to: &writer
			)

			while let next = iterator.next() {
				renderCompilerControlIfConditional(
					"#elseif",
					condition: next.condition,
					statements: next.body.statements,
					to: &writer
				)
			}

			if let elseBody {
				renderCompilerControlIfConditional(
					"#else",
					condition: nil,
					statements: elseBody.statements,
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
		condition: ExpressionDescriptor?,
		statements: [StatementDescriptor],
		to writer: inout CodeWriter
	) {
		writer.indented(to: 0) { writer in
			if let condition {
				writer.writeLine { line in
					line.token(keyword)
					ExpressionRenderer.render(condition, to: &line)
				}
			} else {
				writer.writeLine(keyword)
			}
		}
		StatementRenderer.render(statements, to: &writer)
	}
}

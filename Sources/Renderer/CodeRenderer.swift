//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

struct CodeRenderer: ~Copyable {
	private var writer: CodeFileWriter

	init(indentUsing style: CodeIndentStyle = .spaces(4)) {
		writer = CodeFileWriter(indentUsing: style)
	}

	mutating func renderFile(_ descriptor: FileDescriptor) {
		FileRenderer.render(descriptor, to: &writer)
	}

	consuming func finish() -> Data {
		writer.rendered()
	}

	mutating func renderFunction(_ descriptor: FunctionDescriptor) {
		FunctionRenderer.render(descriptor, to: &writer)
	}

	mutating func renderFunctionSignature(_ descriptor: FunctionSignatureDescriptor) {
		FunctionRenderer.renderSignature(descriptor, to: &writer)
	}

	mutating func renderStruct(_ descriptor: StructDescriptor) {
		StructRenderer.render(descriptor, to: &writer)
	}

	mutating func renderEnum(_ descriptor: AnyEnumDescriptor) {
		EnumRenderer.render(descriptor, to: &writer)
	}

	mutating func renderEnum(_ descriptor: PlainEnumDescriptor) {
		renderEnum(descriptor.descriptor)
	}

	mutating func renderEnum(_ descriptor: RawValueEnumDescriptor<some RawValueEnumValueType>) {
		renderEnum(descriptor.descriptor)
	}

	mutating func renderEnum(_ descriptor: AssociatedValueEnumDescriptor) {
		renderEnum(descriptor.descriptor)
	}

	mutating func renderProtocol(_ descriptor: ProtocolDescriptor) {
		ProtocolRenderer.render(descriptor, to: &writer)
	}

	mutating func renderTypealias(_ descriptor: TypealiasDescriptor) {
		TypealiasRenderer.render(descriptor, to: &writer)
	}

	mutating func renderParametersList(_ descriptor: ParametersList) {
		ParametersListRenderer.render(descriptor, to: &writer)
	}

	mutating func renderStatements(_ descriptors: [StatementDescriptor]) {
		StatementRenderer.render(descriptors, to: &writer)
	}

	mutating func renderStatement(_ descriptor: StatementDescriptor) {
		StatementRenderer.render(descriptor, to: &writer)
	}

	mutating func renderDiagnosticDirective(_ descriptor: DiagnosticDirectiveDescriptor) {
		DiagnosticDirectiveRenderer.render(descriptor, to: &writer)
	}

	mutating func renderMarkComment(_ descriptor: MarkCommentDescriptor) {
		CodeRenderingSupport.renderMarkComment(descriptor, to: &writer)
	}

	mutating func renderInlineComment(_ descriptor: InlineCommentDescriptor) {
		CodeRenderingSupport.renderInlineComment(descriptor, to: &writer)
	}
}

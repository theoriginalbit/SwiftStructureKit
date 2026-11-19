//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum AttributeRenderer {
	static func render(_ attribute: AttributeDescriptor, to writer: inout LineWriter) {
		writer.punctuation(.Prefix.at)
		writer.token(attribute.name)
		var iterator = attribute.arguments.makeIterator()
		if let first = iterator.next() {
			writer.punctuation(.leftParen)
			writer.token(first)
			while let next = iterator.next() {
				writer.punctuation(.comma)
				writer.token(next)
			}
			writer.punctuation(.rightParen)
		}
	}

	static func render(_ attributes: [AttributeDescriptor], to writer: inout CodeWriter) {
		for attribute in attributes {
			writer.writeLine { line in
				render(attribute, to: &line)
			}
		}
	}

	static func render(_ attribute: AttributeDescriptor, to writer: inout TokenWriter) {
		writer.write(.Prefix.at)
		writer.write(attribute.name)
		var iterator = attribute.arguments.makeIterator()
		if let first = iterator.next() {
			writer.write(.leftParen)
			writer.write(first)
			while let next = iterator.next() {
				writer.write(.comma)
				writer.write(next)
			}
			writer.write(.rightParen)
		}
	}
}

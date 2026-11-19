//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum AvailabilityArgumentsListRenderer {
	static func render(_ list: AvailabilityArgumentsList, to writer: inout LineWriter) {
		var iterator = list.elements.makeIterator()
		// we know there will be elements, but the compiler doesn't...do the standard array rendering
		if let first = iterator.next() {
			render(first, to: &writer)
			while let next = iterator.next() {
				writer.punctuation(.comma)
				render(next, to: &writer)
			}
		}
	}

	private static func render(_ descriptor: AvailabilityArgumentDescriptor, to writer: inout LineWriter) {
		switch descriptor {
		case let .platformVersion(platformName, version):
			writer.token(platformName.rawValue)
			writer.token(version.value)
		case .wildcard:
			writer.punctuation(.asterisk)
		case let .keyword(value):
			writer.token(value.rawValue)
		case let .labeledVersion(label, version):
			writer.token(label.rawValue)
			writer.punctuation(.Postfix.colon)
			writer.token(version.value)
		case let .labeledString(label, value):
			writer.token(label.rawValue)
			writer.punctuation(.Postfix.colon)
			writer.token(CodeRenderingSupport.renderedStringLiteral(value))
		}
	}

	static func render(_ descriptor: AvailabilityArgumentDescriptor, to writer: inout TokenWriter) {
		switch descriptor {
		case let .platformVersion(platformName, version):
			writer.write(platformName.rawValue)
			writer.write(version.value)
		case .wildcard:
			writer.write(.asterisk)
		case let .keyword(value):
			writer.write(value.rawValue)
		case let .labeledVersion(label, version):
			writer.write(label.rawValue)
			writer.write(.Postfix.colon)
			writer.write(version.value)
		case let .labeledString(label, value):
			writer.write(label.rawValue)
			writer.write(.Postfix.colon)
			writer.write(CodeRenderingSupport.renderedStringLiteral(value))
		}
	}
}

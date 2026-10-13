//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ProtocolRenderer {
	static func render(_ descriptor: ProtocolDescriptor, to writer: inout CodeFileWriter) {
		CodeRenderingSupport.renderTypeSignature(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			typeKeyword: "protocol",
			identifier: descriptor.identifier,
			genericTypes: descriptor.genericTypes,
			conformances: descriptor.conformances,
			to: &writer
		)
		render(descriptor.members, to: &writer)
		writer.writeLine("}")
	}

	private static func render(_ members: [ProtocolMemberDescriptor], to writer: inout CodeFileWriter) {
		guard !members.isEmpty else { return }
		writer.indented { writer in
			for (index, member) in members.enumerated() {
				render(member, to: &writer)
				if index < members.count - 1 {
					writer.writeNewLine()
				}
			}
		}
	}

	private static func render(_ member: ProtocolMemberDescriptor, to writer: inout CodeFileWriter) {
		switch member {
		case let .associatedtype(descriptor):
			render(descriptor, to: &writer)
		case let .typealias(descriptor):
			TypealiasRenderer.render(descriptor.descriptor, to: &writer)
		case let .property(descriptor):
			render(descriptor, to: &writer)
		case let .function(descriptor):
			FunctionRenderer.renderSignature(descriptor, to: &writer)
		}
	}

	private static func render(_ descriptor: ProtocolAssociatedtypeDescriptor, to writer: inout CodeFileWriter) {
		writer.writeLine { line in
			line.token("associatedtype")
			line.token(CodeRenderingSupport.renderedType(descriptor.identifier))
			switch descriptor.kind {
			case .none: break

			case let .conformsTo(conformingType):
				line.punctuation(":")
				line.token(CodeRenderingSupport.renderedType(conformingType))

			case let .sameType(assignedType):
				line.token("=")
				line.token(CodeRenderingSupport.renderedType(assignedType))
			}
		}
	}

	private static func render(_ property: ProtocolPropertyDescriptor, to writer: inout CodeFileWriter) {
		if let comment = property.comment {
			writer.writeLine(comment.value, prefix: "/// ")
		}

		writer.writeLine { line in
			line.token("var")
			line.token(property.identifier)
			line.punctuation(":")
			line.token(CodeRenderingSupport.renderedType(property.type))
			line.token("{")
			switch property.accessorSpecifier {
			case .get: line.token("get")
			case .getSet: line.token("get set")
			case .borrow: line.token("borrow")
			case .borrowMutate: line.token("borrow mutate")
			}
			line.token("}")
		}
	}
}

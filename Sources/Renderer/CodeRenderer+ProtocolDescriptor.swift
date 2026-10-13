//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

extension CodeRenderer {
	func renderProtocol(_ descriptor: ProtocolDescriptor) {
		renderProtocol(descriptor, to: &writer)
	}

	func renderProtocol(_ descriptor: ProtocolDescriptor, to writer: inout CodeFileWriter) {
		renderTypeSignature(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			typeKeyword: "protocol",
			identifier: descriptor.identifier,
			genericTypes: descriptor.genericTypes,
			conformances: descriptor.conformances,
			to: &writer
		)
		renderProtocolMembers(descriptor.members, to: &writer)

		writer.writeLine("}")
	}

	func renderProtocolMembers(_ members: [ProtocolMemberDescriptor], to writer: inout CodeFileWriter) {
		guard !members.isEmpty else { return }
		writer.indented { writer in
			for (index, member) in members.enumerated() {
				renderProtocolMember(member, to: &writer)
				if index < members.count - 1 {
					writer.writeNewLine()
				}
			}
		}
	}

	func renderProtocolMember(_ member: ProtocolMemberDescriptor, to writer: inout CodeFileWriter) {
		switch member {
		case let .associatedtype(descriptor):
			renderAssociatedtype(descriptor, to: &writer)
		case let .typealias(descriptor):
			renderTypealias(descriptor.descriptor, to: &writer)
		case let .property(descriptor):
			renderProtocolProperty(descriptor, to: &writer)
		case let .function(descriptor):
			renderFunctionSignature(descriptor, to: &writer)
		}
	}

	func renderAssociatedtype(_ descriptor: ProtocolAssociatedtypeDescriptor, to writer: inout CodeFileWriter) {
		writer.writeLine { line in
			line.token("associatedtype")
			line.token(renderedType(descriptor.identifier))
			switch descriptor.kind {
			case .none: break

			case let .conformsTo(conformingType):
				line.punctuation(":")
				line.token(renderedType(conformingType))

			case let .sameType(assignedType):
				line.token("=")
				line.token(renderedType(assignedType))
			}
		}
	}

	func renderProtocolProperty(_ property: ProtocolPropertyDescriptor , to writer: inout CodeFileWriter) {
		if let comment = property.comment{
			writer.writeLine(comment.value, prefix: "/// ")
		}

		writer.writeLine { line in
			line.token("var")
			line.token(property.identifier)
			line.punctuation(":")
			line.token(renderedType(property.type))
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

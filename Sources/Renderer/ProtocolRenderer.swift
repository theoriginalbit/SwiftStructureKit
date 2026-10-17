//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum ProtocolRenderer {
	static func render(_ descriptor: ProtocolDescriptor, to writer: inout CodeWriter) {
		CodeRenderingSupport.renderTypeDeclaration(
			comment: descriptor.comment,
			accessModifier: descriptor.accessModifier,
			attributes: descriptor.attributes,
			typeKeyword: "protocol",
			identifier: descriptor.identifier,
			genericParameters: descriptor.genericParameters,
			genericRequirements: descriptor.genericRequirements,
			conformances: descriptor.conformances,
			to: &writer
		) { writer in
			writer.writeSeparated(descriptor.members, render(_:to:))
		}
	}

	private static func render(_ member: ProtocolMemberDescriptor, to writer: inout CodeWriter) {
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

	private static func render(_ descriptor: ProtocolAssociatedtypeDescriptor, to writer: inout CodeWriter) {
		writer.writeLine { line in
			line.token("associatedtype")
			line.token(SwiftIdentifier.sanitized(descriptor.name))
			switch descriptor.kind {
			case .none:
				break

			case let .conformsTo(conformingType):
				line.punctuation(.colon)
				line.token(CodeRenderingSupport.renderedComposition(conformingType))

			case let .defaultType(assignedType):
				line.punctuation(.equal)
				line.token(CodeRenderingSupport.renderedType(assignedType))
			}
		}
	}

	private static func render(_ property: ProtocolPropertyDescriptor, to writer: inout CodeWriter) {
		CommentRenderer.renderDocComment(property.comment, to: &writer)
		AttributeRenderer.render(property.attributes, to: &writer)

		writer.writeLine { line in
			line.token("var")
			line.token(SwiftIdentifier.sanitized(property.identifier))
			line.punctuation(.colon)
			line.token(CodeRenderingSupport.renderedType(property.type))
			line.punctuation(.leftBrace)
			switch property.accessorSpecifier {
			case .get: line.token("get")
			case .getSet: line.token("get set")
			case .borrow: line.token("borrow")
			case .borrowMutate: line.token("borrow mutate")
			}
			line.punctuation(.rightBrace)
		}
	}
}

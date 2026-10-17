//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

enum AttributeRenderer {
	static func render(_ attribute: AttributeDescriptor, to line: inout LineWriter) {
		line.token(rendered(attribute))
	}

	static func render(_ attributes: [AttributeDescriptor], to writer: inout CodeWriter) {
		for attribute in attributes {
			writer.writeLine(rendered(attribute))
		}
	}

	static func rendered(_ attribute: AttributeDescriptor) -> String {
		switch attribute {
		case let .rawValue(name):
			"@\(name.hasPrefix("@") ? String(name.dropFirst()) : name)"
		case let .resultBuilder(name):
			"@\(name.hasPrefix("@") ? String(name.dropFirst()) : name)"
		case let .available(availability):
			"@available(\(availability))"
		case let .objectiveC(name):
			if let name {
				"@objc(\(name))"
			} else {
				"@objc"
			}
		case .mainActor:
			"@MainActor"
		case .sendable:
			"@Sendable"
		case .escaping:
			"@escaping"
		case .frozen:
			"@frozen"
		case .inlinable:
			"@inlinable"
		case .discardableResult:
			"@discardableResult"
		case .disfavoredOverload:
			"@_disfavoredOverload"
		}
	}
}

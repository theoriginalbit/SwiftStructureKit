//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An import statement in a Swift source file.
public struct ImportDescriptor: Sendable {
	/// The kind of declaration being imported, when the import is kind-qualified.
	public enum Kind: String, Sendable {
		case classType = "class"
		case enumeration = "enum"
		case function = "func"
		case `protocol` = "protocol"
		case structure = "struct"
		case `typealias` = "typealias"
	}

	/// The module being imported.
	public let moduleName: String

	/// An optional submodule or symbol within the module.
	public let submodule: String?

	/// The access level specified for the import, if any.
	public let accessModifier: AccessModifierDescriptor?

	/// Attributes attached to the import, such as `@_exported` or `@testable`.
	public let attributes: [String]

	/// The imported declaration kind, if this is a kind-qualified import.
	public let kind: Kind?

	/// Creates an import descriptor.
	///
	/// - Parameters:
	///   - moduleName: The module to import.
	///   - submodule: An optional submodule or symbol within the module.
	///   - accessModifier: An optional access level modifier for the import.
	///   - attributes: Attributes attached to the import. The leading `@` is optional.
	///   - kind: An optional declaration kind for a kind-qualified import.
	public init(
		_ moduleName: String,
		submodule: String? = nil,
		accessModifier: AccessModifierDescriptor? = nil,
		attributes: [String] = [],
		kind: Kind? = nil,
	) {
		self.moduleName = moduleName
		self.submodule = submodule
		self.accessModifier = accessModifier
		self.attributes = attributes
		self.kind = kind
	}
}

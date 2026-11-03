//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// Type-erased representation of any enumeration case declaration.
public struct AnyEnumCaseDescriptor: Sendable {
	/// The name identifier of the enum case.
	public let name: String

	/// The raw value associated with the enum case, if any.
	public let rawValue: LiteralDescriptor?

	/// The associated values attached to the enum case.
	public let associatedValues: [EnumCaseAssociatedValueDescriptor]

	/// The documentation comment attached to the enum case declaration, if any.
	public let comment: DocCommentDescriptor?

	internal init(
		name: String,
		rawValue: LiteralDescriptor?,
		associatedValues: [EnumCaseAssociatedValueDescriptor],
		comment: DocCommentDescriptor?
	) {
		self.name = name
		self.rawValue = rawValue
		self.associatedValues = associatedValues
		self.comment = comment
	}
}

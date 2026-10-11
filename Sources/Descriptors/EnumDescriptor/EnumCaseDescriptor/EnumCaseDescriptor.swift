//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a case declaration within a Swift enumeration.
public struct EnumCaseDescriptor<Mode: EnumMode>: Sendable {
	/// The name identifier of the enum case.
	public let name: String

	/// The raw value associated with the enum case, if any.
	public let rawValue: LiteralDescriptor?

	/// The associated values attached to the enum case.
	public let associatedValues: [AssociatedValueDescriptor]

	/// The documentation comment attached to the enum case declaration, if any.
	public let comment: DocCommentDescriptor?
}

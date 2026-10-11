//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An enum kind representing plain enumerations that have neither raw values nor associated values.
public struct PlainEnumMode: EnumMode {}

/// A convenience type alias for an enum case descriptor within a plain enumeration.
public typealias PlainEnumCase = EnumCaseDescriptor<PlainEnumMode>

// MARK: - Enum Case Construction Conveniences

extension PlainEnumCase {
	/// Creates a plain enum case with a name and optional documentation comment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - comment: An optional documentation comment for the case.
	public init(_ name: String, comment: DocCommentDescriptor? = nil) {
		self.name = name
		self.rawValue = nil
		self.associatedValues = []
		self.comment = comment
	}
}

extension ArrayBuilder where T == PlainEnumCase {
	/// Converts a string expression into a single-element array containing a plain enum case descriptor.
	public static func buildExpression(_ statement: String) -> Result {
		[EnumCaseDescriptor(statement)]
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a case declaration within a Swift enumeration.
@dynamicMemberLookup
public struct PlainEnumCaseDescriptor: Sendable {
	let descriptor: AnyEnumCaseDescriptor

	public subscript<T>(dynamicMember keyPath: KeyPath<AnyEnumCaseDescriptor, T>) -> T {
		descriptor[keyPath: keyPath]
	}

	/// Creates a plain enum case with a name and optional documentation comment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - comment: An optional documentation comment for the case.
	public init(
		_ name: String,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: nil,
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension ArrayBuilder<PlainEnumCaseDescriptor> {
	static func buildExpression(_ statement: String) -> [T] {
		[T(statement)]
	}
}

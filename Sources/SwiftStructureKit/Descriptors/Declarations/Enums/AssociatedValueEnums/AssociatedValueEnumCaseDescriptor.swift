//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a case declaration within a Swift enumeration.
@dynamicMemberLookup
public struct AssociatedValueEnumCaseDescriptor: Sendable {
	let descriptor: AnyEnumCaseDescriptor

	public subscript<T>(dynamicMember keyPath: KeyPath<AnyEnumCaseDescriptor, T>) -> T {
		descriptor[keyPath: keyPath]
	}

	/// Creates an associated-value enum case with associated values and an optional documentation comment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - associatedValues: The associated values for the case.
	///   - comment: An optional documentation comment for the case.
	public init(
		_ name: String,
		associatedValues: [EnumCaseAssociatedValueDescriptor] = [],
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: nil,
			associatedValues: associatedValues,
			comment: comment,
		)
	}
}

public extension ArrayBuilder<AssociatedValueEnumCaseDescriptor> {
	static func buildExpression(_ statement: String) -> [T] {
		[T(statement)]
	}
}

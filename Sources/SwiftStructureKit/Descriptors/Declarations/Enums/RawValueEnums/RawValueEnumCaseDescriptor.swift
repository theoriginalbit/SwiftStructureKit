//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A descriptor representing a enum case declaration that has a raw value.
@dynamicMemberLookup
public struct RawValueEnumCaseDescriptor<TypeRef: RawValueEnumValueType>: Sendable {
	let descriptor: AnyEnumCaseDescriptor

	public subscript<T>(dynamicMember keyPath: KeyPath<AnyEnumCaseDescriptor, T>) -> T {
		descriptor[keyPath: keyPath]
	}

	/// Creates a raw-value enum case with an explicit raw value and optional documentation comment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - rawValue: The strongly-typed raw value literal for the case.
	///   - comment: An optional documentation comment for the case.
	public init(
		_ name: String,
		rawValue: RawValueEnumDescriptor<TypeRef>.RawValueLiteral,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: rawValue.literal,
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == String {
	/// Creates a string raw-value enum case without an explicit raw value assignment.
	///
	/// - Parameters:
	///   - name: The name of the enum case.
	///   - comment: An optional documentation comment for the case.
	init(
		_ name: String,
		comment: DocCommentDescriptor? = nil,
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: nil, // by specifying `nil` it means it won't get rendered and use the name
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == String {
	/// Creates a string raw-value enum case with an explicit raw value.
	///
	/// - Parameters:
	///   - name: The enum case name.
	///   - rawValue: The string raw value.
	///   - comment: An optional documentation comment for the case.
	init(
		_ name: String,
		rawValue: TypeRef,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: .string(rawValue),
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == Int {
	/// Creates an integer raw-value enum case with an explicit raw value.
	///
	/// - Parameters:
	///   - name: The enum case name.
	///   - rawValue: The integer raw value.
	///   - comment: An optional documentation comment for the case.
	init(
		_ name: String,
		rawValue: TypeRef,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: .integer(rawValue),
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == Double {
	/// Creates a floating-point raw-value enum case with an explicit raw value.
	///
	/// - Parameters:
	///   - name: The enum case name.
	///   - rawValue: The floating-point raw value.
	///   - comment: An optional documentation comment for the case.
	init(
		_ name: String,
		rawValue: TypeRef,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: .double(rawValue),
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension RawValueEnumCaseDescriptor where TypeRef == Bool {
	/// Creates a Boolean raw-value enum case with an explicit raw value.
	///
	/// - Parameters:
	///   - name: The enum case name.
	///   - rawValue: The Boolean raw value.
	///   - comment: An optional documentation comment for the case.
	init(
		_ name: String,
		rawValue: TypeRef,
		comment: DocCommentDescriptor? = nil
	) {
		self.descriptor = AnyEnumCaseDescriptor(
			name: name,
			rawValue: .boolean(rawValue),
			associatedValues: [],
			comment: comment,
		)
	}
}

public extension ArrayBuilder<RawValueEnumCaseDescriptor<String>> {
	static func buildExpression(_ statement: String) -> [T] {
		[T(statement)]
	}
}

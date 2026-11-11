//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A dictionary literal item.
///
/// For example:
/// ```swift
/// let dict = [
///   "foo": "bar",
/// ]
/// ```
/// The item represents `"foo": "bar"`.
public struct DictionaryLiteralItemDescriptor: Sendable {
	/// The expression representing the key.
	public let key: ExpressionDescriptor

	/// The expression representing the value
	public let value: ExpressionDescriptor

	public init(key: ExpressionDescriptor, value: ExpressionDescriptor) {
		self.key = key
		self.value = value
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// Stores a Swift identifier candidate.
///
/// Validates/sanitises per the grammar of an identifier.
/// > Grammar:
/// > [](https://docs.swift.org/latest/documentation/the-swift-programming-language/summaryofthegrammar/#Lexical-Structure)
public struct IdentifierDescriptor: Sendable {
	public let value: String

	/// Creates an identifier with the supplied value.
	public init(_ value: String) {
		self.value = value
	}
}

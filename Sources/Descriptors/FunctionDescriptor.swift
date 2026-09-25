//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A function.
public struct FunctionDescriptor: Sendable {
	/// The signature of the function.
	public let signature: FunctionSignatureDescriptor

	/// The body definition of the function.
	public let body: CodeBlockDescriptor?

	/// Creates a function descriptor with a signature and optional body code block.
	public init(
		signature: FunctionSignatureDescriptor,
		body: CodeBlockDescriptor? = nil
	) {
		self.signature = signature
		self.body = body
	}

	/// Creates a function descriptor with a signature and result builder body.
	public init(
		signature: FunctionSignatureDescriptor,
		@CodeBlockBuilder body: () -> [StatementDescriptor]
	) {
		self.signature = signature
		self.body = CodeBlockDescriptor(body)
	}
}

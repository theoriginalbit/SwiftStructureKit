//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A function.
public struct FunctionDescriptor: Sendable {
	/// The signature of the function.
	public let signature: FunctionSignatureDescriptor

	/// The body definition of the function.
	public let body: CodeBlockDescriptor?

	/// Creates a function descriptor with a signature and result builder body.
	public init(
		signature: FunctionSignatureDescriptor,
		@CodeBlockDescriptor.Builder body: () -> CodeBlockDescriptor.Builder.Result,
	) {
		self.signature = signature
		self.body = CodeBlockDescriptor(body)
	}
}

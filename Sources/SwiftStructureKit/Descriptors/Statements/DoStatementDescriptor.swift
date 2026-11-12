//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// Describes a `do` statement and its optional `catch` block.
///
/// Use this descriptor to represent statements that execute in a `do` block,
/// optionally followed by a `catch` block.
public struct DoStatementDescriptor: Sendable {
	/// The statements executed inside the `do` block.
	public let body: CodeBlockDescriptor

	/// The statements executed inside the `catch` block.
	///
	/// If `nil` no `catch` statement is added.
	public let catchBody: CodeBlockDescriptor?

	/// Creates a descriptor for a `do` statement.
	///
	/// - Parameters:
	///   - body: The statements to execute inside the `do` block.
	///   - catchBody: The statements to execute inside the optional `catch` block.
	public init(_ body: CodeBlockDescriptor, catch catchBody: CodeBlockDescriptor? = nil) {
		self.body = body
		self.catchBody = catchBody
	}
}

public extension StatementDescriptor {
	/// Creates a `do` statement from a code block descriptor.
	///
	/// - Parameter body: The statements to execute inside the `do` block.
	/// - Returns: A statement descriptor representing a `do` statement without a `catch` block.
	static func `do`(_ body: CodeBlockDescriptor) -> Self {
		.do(DoStatementDescriptor(body, catch: nil))
	}

	/// Creates a `do` statement from a result-builder body.
	///
	/// - Parameter body: A closure that builds the statements to execute inside the `do` block.
	/// - Returns: A statement descriptor representing a `do` statement without a `catch` block.
	static func `do`(@CodeBlockBuilder body: () -> [StatementDescriptor]) -> Self {
		.do(DoStatementDescriptor(CodeBlockDescriptor(body), catch: nil))
	}

	/// Creates a `do` statement with a `catch` block from code block descriptors.
	///
	/// - Parameters:
	///   - body: The statements to execute inside the `do` block.
	///   - catchBody: The statements to execute inside the `catch` block.
	/// - Returns: A statement descriptor representing a `do` statement with a `catch` block.
	static func `do`(_ body: CodeBlockDescriptor, catch catchBody: CodeBlockDescriptor) -> Self {
		.do(DoStatementDescriptor(body, catch: catchBody))
	}

	/// Creates a `do` statement with a `catch` block from result-builder bodies.
	///
	/// - Parameters:
	///   - body: A closure that builds the statements to execute inside the `do` block.
	///   - catchBody: A closure that builds the statements to execute inside the `catch` block.
	/// - Returns: A statement descriptor representing a `do` statement with a `catch` block.
	static func `do`(
		@CodeBlockBuilder body: () -> [StatementDescriptor],
		@CodeBlockBuilder catch catchBody: () -> [StatementDescriptor]
	) -> Self {
		.do(DoStatementDescriptor(
			CodeBlockDescriptor(body),
			catch: CodeBlockDescriptor(catchBody),
		))
	}
}

public extension LabeledStatementDescriptor.Statement {
	/// Creates a `do` statement from a code block descriptor.
	///
	/// - Parameter body: The statements to execute inside the `do` block.
	/// - Returns: A statement descriptor representing a `do` statement without a `catch` block.
	static func `do`(_ body: CodeBlockDescriptor) -> Self {
		.do(DoStatementDescriptor(body, catch: nil))
	}

	/// Creates a `do` statement from a result-builder body.
	///
	/// - Parameter body: A closure that builds the statements to execute inside the `do` block.
	/// - Returns: A statement descriptor representing a `do` statement without a `catch` block.
	static func `do`(@CodeBlockBuilder body: () -> [StatementDescriptor]) -> Self {
		.do(DoStatementDescriptor(CodeBlockDescriptor(body), catch: nil))
	}

	/// Creates a `do` statement with a `catch` block from code block descriptors.
	///
	/// - Parameters:
	///   - body: The statements to execute inside the `do` block.
	///   - catchBody: The statements to execute inside the `catch` block.
	/// - Returns: A statement descriptor representing a `do` statement with a `catch` block.
	static func `do`(_ body: CodeBlockDescriptor, catch catchBody: CodeBlockDescriptor) -> Self {
		.do(DoStatementDescriptor(body, catch: catchBody))
	}

	/// Creates a `do` statement with a `catch` block from result-builder bodies.
	///
	/// - Parameters:
	///   - body: A closure that builds the statements to execute inside the `do` block.
	///   - catchBody: A closure that builds the statements to execute inside the `catch` block.
	/// - Returns: A statement descriptor representing a `do` statement with a `catch` block.
	static func `do`(
		@CodeBlockBuilder body: () -> [StatementDescriptor],
		@CodeBlockBuilder catch catchBody: () -> [StatementDescriptor]
	) -> Self {
		.do(DoStatementDescriptor(
			CodeBlockDescriptor(body),
			catch: CodeBlockDescriptor(catchBody),
		))
	}
}

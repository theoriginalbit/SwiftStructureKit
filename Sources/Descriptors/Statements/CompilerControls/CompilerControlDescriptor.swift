//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A compiler-control construct that can appear in a Swift source file.
///
/// Use this descriptor to represent either a diagnostic directive or a conditional
/// compilation statement.
public enum CompilerControlDescriptor: Sendable {
	/// A compiler diagnostic directive that emits a `#warning` or `#error`.
	///
	/// - Parameter descriptor: The diagnostic directive to render.
	case directive(DiagnosticDirectiveDescriptor)

	/// A conditional compilation statement beginning with `#if`.
	///
	/// - Parameter descriptor: The conditional statement and its branches.
	case conditional(CompilerConditionalStatementDescriptor)
}

extension ArrayBuilder<StatementDescriptor> {
	public static func buildExpression(_ expression: CompilerControlDescriptor) -> Result {
		[.compilerControl(expression)]
	}
}

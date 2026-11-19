//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public enum TopLevelCompilerControlDescriptor: Sendable {
	/// A compiler diagnostic directive that emits a `#warning` or `#error`.
	///
	/// - Parameter descriptor: The diagnostic directive to render.
	case directive(DiagnosticDirectiveDescriptor)

	/// A conditional compilation statement beginning with `#if`.
	///
	/// - Parameter descriptor: The conditional statement and its branches.
	case conditional(TopLevelCompilerConditionalDescriptor)
}

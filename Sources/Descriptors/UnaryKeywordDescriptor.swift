//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// An expression that places a keyword before an expression.
public enum UnaryKeywordDescriptor: Sendable {
	/// The return keyword.
	case `return`(ExpressionDescriptor?)

	/// The try keyword.
	case `try`(hasPostfixQuestionMark: Bool, ExpressionDescriptor)

	/// The await keyword.
	case `await`(ExpressionDescriptor)

	/// The throw keyword.
	case `throw`(ExpressionDescriptor)
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public struct DiagnosticSpec {
	var anyOf: [String]
	var line: Int? = nil
	var column: Int? = nil
	var severity = "error"

	public init(
		anyOf: [String],
		line: Int? = nil,
		column: Int? = nil,
		severity: String = "error",
	) {
		self.anyOf = anyOf
		self.line = line
		self.column = column
		self.severity = severity
	}
}

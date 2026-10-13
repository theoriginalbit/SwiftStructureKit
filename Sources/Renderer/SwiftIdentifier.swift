//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

enum SwiftIdentifier {
	static func sanitized(_ identifier: String) -> String {
		guard !identifier.isEmpty else { return "_empty" }
		if identifier == "_" { return identifier }

		let firstCharacterSet = CharacterSet.letters.union(CharacterSet(charactersIn: "_$"))
		let digits = CharacterSet.decimalDigits
		let otherCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))

		var sanitizedScalars: [Unicode.Scalar] = []
		for (index, scalar) in identifier.unicodeScalars.enumerated() {
			let allowedCharacterSet = index == 0 ? firstCharacterSet : otherCharacterSet
			if allowedCharacterSet.contains(scalar) {
				sanitizedScalars.append(scalar)
			} else if index == 0, digits.contains(scalar) {
				sanitizedScalars.append("_")
				sanitizedScalars.append(scalar)
			} else {
				sanitizedScalars.append("_")
				if let entityName = specialCharacters[scalar] {
					sanitizedScalars.append(contentsOf: entityName.unicodeScalars)
				} else {
					sanitizedScalars.append("x")
					sanitizedScalars.append(contentsOf: String(scalar.value, radix: 16, uppercase: true).unicodeScalars)
				}
				sanitizedScalars.append("_")
			}
		}

		let sanitized = String(String.UnicodeScalarView(sanitizedScalars))
		if sanitized == "_" { return "_" }
		return keywords.contains(sanitized) ? "`\(sanitized)`" : sanitized
	}

	private static let keywords: Set<String> = [
		"associatedtype",
		"class",
		"deinit",
		"enum",
		"extension",
		"func",
		"import",
		"init",
		"inout",
		"let",
		"operator",
		"precedencegroup",
		"protocol",
		"struct",
		"subscript",
		"typealias",
		"var",
		"fileprivate",
		"internal",
		"private",
		"public",
		"static",
		"defer",
		"if",
		"guard",
		"do",
		"repeat",
		"else",
		"for",
		"in",
		"while",
		"return",
		"break",
		"continue",
		"fallthrough",
		"switch",
		"case",
		"default",
		"where",
		"catch",
		"throw",
		"as",
		"false",
		"is",
		"nil",
		"rethrows",
		"self",
		"Self",
		"super",
		"true",
		"try",
		"throws",
		"yield",
		"await",
	]

	private static let specialCharacters: [Unicode.Scalar: String] = [
		" ": "space",
		"!": "exclaim",
		"\"": "quote",
		"#": "num",
		"$": "dollar",
		"%": "percent",
		"&": "amp",
		"'": "apos",
		"(": "lparen",
		")": "rparen",
		"*": "asterisk",
		"+": "plus",
		",": "comma",
		"-": "hyphen",
		".": "period",
		"/": "fslash",
		":": "colon",
		";": "semicolon",
		"<": "lt",
		"=": "equals",
		">": "gt",
		"?": "question",
		"@": "atmark",
		"[": "lbrack",
		"\\": "bslash",
		"]": "rbrack",
		"^": "hat",
		"`": "grave",
		"{": "lbrace",
		"|": "vertbar",
		"}": "rbrace",
		"~": "tilde",
	]
}

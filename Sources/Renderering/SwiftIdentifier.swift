//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

enum SwiftIdentifier {
	/// The syntactic position an identifier is rendered in. The set of keywords that
	/// must be escaped with backticks depends on where the identifier appears.
	enum Position {
		/// The name being introduced by a declaration, such as a type, property,
		/// function, enum case or parameter name.
		///
		/// Every reserved word is escaped.
		case declaration

		/// The leading component of an expression.
		///
		/// Reserved words are escaped, except those that are meaningful references
		/// in their own right (`self`, `Self`, `super`, `init`, `Any`).
		///
		/// A leading `$` is permitted for projected values and anonymous closure
		/// arguments.
		case reference

		/// A component following a `.` in an expression.
		///
		/// Any keyword is permitted here (SE-0071), so nothing is escaped, and
		/// projections such as `$value` are allowed.
		case memberAccess

		/// The leading component of a type name.
		///
		/// Escaped like ``reference`` but `$` is never legal in a type name.
		case type

		/// A component following a `.` in a qualified type name.
		///
		/// Nothing is escaped and `$` is never legal.
		case nestedType

		/// An argument, parameter, tuple element or associated value label.
		///
		/// Any keyword is permitted except `inout`, `var` and `let`.
		case argumentLabel

		/// A name referenced inside a documentation comment.
		///
		/// Escaped like ``declaration`` but backticks are never emitted because
		/// DocC matches on the bare name.
		case documentation

		/// Whether a leading `$` is legal in this position.
		fileprivate var allowsDollarPrefix: Bool {
			switch self {
			case .reference, .memberAccess: true
			case .declaration, .argumentLabel, .documentation, .type, .nestedType: false
			}
		}

		/// Whether a `_` is legal in this position.
		fileprivate var allowsWildcard: Bool {
			switch self {
			case .declaration, .argumentLabel: true
			case .reference, .memberAccess, .type, .nestedType, .documentation: false
			}
		}
	}

	static func sanitized(_ identifier: String, position: Position = .declaration) -> String {
		guard !identifier.isEmpty else { return "_empty" }

		// check if already santisised, validity of sanitisation won't be checked
		if identifier.hasPrefix("`") && identifier.hasSuffix("`") { return identifier }

		// allow _ as assignment wildcards and function parameter omissions
		if position.allowsWildcard, identifier == "_" { return identifier }

		// A leading `$` may not be declared, but it is how projected values (`$binding`,
		// `self.$binding`) and anonymous closure arguments (`$0`) are referenced. A dollar
		// identifier is a single token, so keywords never need escaping after the `$`.
		if position.allowsDollarPrefix, identifier.count > 1, identifier.hasPrefix("$") {
			let rest = String(identifier.dropFirst())
			// check if it is an anonymous closure argument
			if rest.utf8.allSatisfy(\.isASCIIDigit) {
				return identifier
			}
			return "$" + sanitizedCharacters(rest)
		}

		let sanitized = sanitizedCharacters(identifier)
		if sanitized == "_" { return "_" }
		return if requiresEscaping(sanitized, in: position) {
			"`\(sanitized)`"
		} else {
			sanitized
		}
	}

	private static let firstCharacterSet = CharacterSet.letters.union(CharacterSet(charactersIn: "_"))
	private static let digits = CharacterSet.decimalDigits
	private static let otherCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))

	/// Rewrites `identifier` so that it only contains characters that are valid in a Swift
	/// identifier. Keyword escaping is left to the caller.
	private static func sanitizedCharacters(_ identifier: String) -> String {
		// The overwhelmingly common case will be developers providing a plain ASCII
		// identifier; it would already be valid and needs no character substitution.
		if isPlainASCIIIdentifier(identifier) {
			return identifier
		}

		var scalars: [Unicode.Scalar] = []
		scalars.reserveCapacity(identifier.unicodeScalars.count)
		for (index, scalar) in identifier.unicodeScalars.enumerated() {
			let allowedCharacterSet = index == 0 ? firstCharacterSet : otherCharacterSet
			if allowedCharacterSet.contains(scalar) {
				scalars.append(scalar)
			} else if index == 0, digits.contains(scalar) {
				scalars.append("_")
				scalars.append(scalar)
			} else {
				scalars.append("_")
				if let entityName = specialCharacters[scalar] {
					scalars.append(contentsOf: entityName.unicodeScalars)
				} else {
					scalars.append("x")
					scalars.append(contentsOf: String(scalar.value, radix: 16, uppercase: true).unicodeScalars)
				}
				scalars.append("_")
			}
		}

		return String(String.UnicodeScalarView(scalars))
	}

	private static func isPlainASCIIIdentifier(_ identifier: String) -> Bool {
		var iterator = identifier.utf8.makeIterator()

		// The first character must be a letter or underscore
		guard let first = iterator.next(), first.isIdentifierFirst else {
			return false
		}

		// The remaining characters are a bit more relaxed and can include numbers.
		while let byte = iterator.next() {
			guard byte.isIdentifierBody else {
				return false
			}
		}

		return true
	}

	// MARK: Keywords

	private static func requiresEscaping(_ identifier: String, in position: Position) -> Bool {
		switch position {
		case .declaration:
			return keywords.contains(identifier)
		case .reference, .type:
			return keywords.contains(identifier) && !referenceKeywords.contains(identifier)
		case .memberAccess, .nestedType, .documentation:
			return false
		case .argumentLabel:
			return argumentLabelKeywords.contains(identifier)
		}
	}

	/// Keywords that are valid as the leading component of a reference without escaping.
	private static let referenceKeywords: Set<String> = [
		"self",
		"Self",
		"super",
		"init",
		"Any",
	]

	/// The only keywords that may not be used as an argument label without escaping.
	private static let argumentLabelKeywords: Set<String> = [
		"inout",
		"var",
		"let",
	]

	/// Keywords that must be escaped when used in declarations, types, and references.
	private static let keywords: Set<String> = [
		"Any",
		"Self",
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
		"self",
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

private extension UInt8 {
	@inline(__always) var isASCIILetter: Bool { (self | 0x20) &- 0x61 < 26 }
	@inline(__always) var isASCIIDigit: Bool { self &- 0x30 < 10 }
	@inline(__always) var isASCIIUnderscore: Bool { self == 0x5F }
	@inline(__always) var isIdentifierFirst: Bool { isASCIILetter || isASCIIUnderscore }
	@inline(__always) var isIdentifierBody: Bool { isIdentifierFirst || isASCIIDigit }
}

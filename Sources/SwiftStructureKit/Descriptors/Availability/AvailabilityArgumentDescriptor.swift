//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

/// A single argument within an availability attribute or condition.
///
/// Availability arguments come in several forms:
///
/// - **Platform version**: `iOS 16`, `macOS 13.0`
/// - **Wildcard**: `*` (indicates all other platforms)
/// - **Keyword**: `unavailable`, `noasync`
/// - **Labelled version**: `introduced: 1.0`, `deprecated: 2.0`, `obsoleted: 3.0`
/// - **Labelled string**: `message: "Use something else"`, `renamed: "newName"`
public enum AvailabilityArgumentDescriptor: Hashable, Sendable {
	/// A platform and its version, e.g. `iOS 16` or `macOS 13.0`.
	case platformVersion(platformName: PlatformName, version: PlatformVersion)

	/// The wildcard `*`, indicating all other platforms.
	case wildcard

	/// A standalone keyword such as `unavailable` or `noasync`.
	///
	/// `noasync` is supported with the wildcard argument, as in `@available(*, noasync)`.
	case keyword(Keyword)

	/// A labelled version argument, e.g. `introduced: 1.0` or `deprecated: 2.0`.
	case labeledVersion(_ label: VersionLabel, version: PlatformVersion)

	/// A labelled string argument, e.g. `message: "Use something else"` or `renamed: "newName"`.
	case labeledString(_ label: StringLabel, value: String)
}

// MARK: - Supporting types

public extension AvailabilityArgumentDescriptor {
	enum Keyword: String, Hashable, Sendable {
		case unavailable
		case noasync
	}

	enum VersionLabel: String, Hashable, Sendable {
		case introduced
		case deprecated
		case obsoleted
	}

	enum StringLabel: String, Hashable, Sendable {
		case message
		case renamed
	}
}

// MARK: - Platform conveniences

public extension AvailabilityArgumentDescriptor {
	/// Creates a platform version argument.
	static func platform(_ platform: PlatformName, _ version: PlatformVersion) -> Self {
		.platformVersion(platformName: platform, version: version)
	}

	static func iOS(_ version: PlatformVersion) -> Self {
		.platform(.iOS, version)
	}

	static func macOS(_ version: PlatformVersion) -> Self {
		.platform(.macOS, version)
	}

	static func macCatalyst(_ version: PlatformVersion) -> Self {
		.platform(.macCatalyst, version)
	}

	static func watchOS(_ version: PlatformVersion) -> Self {
		.platform(.watchOS, version)
	}

	static func tvOS(_ version: PlatformVersion) -> Self {
		.platform(.tvOS, version)
	}

	static func visionOS(_ version: PlatformVersion) -> Self {
		.platform(.visionOS, version)
	}

	static func iOSApplicationExtension(_ version: PlatformVersion) -> Self {
		.platform(.iOSApplicationExtension, version)
	}

	static func macOSApplicationExtension(_ version: PlatformVersion) -> Self {
		.platform(.macOSApplicationExtension, version)
	}

	static func macCatalystApplicationExtension(_ version: PlatformVersion) -> Self {
		.platform(.macCatalystApplicationExtension, version)
	}

	static func watchOSApplicationExtension(_ version: PlatformVersion) -> Self {
		.platform(.watchOSApplicationExtension, version)
	}

	static func tvOSApplicationExtension(_ version: PlatformVersion) -> Self {
		.platform(.tvOSApplicationExtension, version)
	}

	static func visionOSApplicationExtension(_ version: PlatformVersion) -> Self {
		.platform(.visionOSApplicationExtension, version)
	}
}

// MARK: - Keyword conveniences

public extension AvailabilityArgumentDescriptor {
	/// The `unavailable` keyword argument.
	static var unavailable: Self {
		.keyword(.unavailable)
	}

	/// The `noasync` keyword argument.
	static var noasync: Self {
		.keyword(.noasync)
	}
}

// MARK: - Labelled argument conveniences

public extension AvailabilityArgumentDescriptor {
	/// An `introduced:` version argument, e.g. `introduced: 1.0`.
	static func introduced(_ version: PlatformVersion) -> Self {
		.labeledVersion(.introduced, version: version)
	}

	/// A `deprecated:` version argument, e.g. `deprecated: 2.0`.
	static func deprecated(_ version: PlatformVersion) -> Self {
		.labeledVersion(.deprecated, version: version)
	}

	/// An `obsoleted:` version argument, e.g. `obsoleted: 3.0`.
	static func obsoleted(_ version: PlatformVersion) -> Self {
		.labeledVersion(.obsoleted, version: version)
	}

	/// A `message:` string argument, e.g. `message: "Use something else"`.
	static func message(_ value: String) -> Self {
		.labeledString(.message, value: value)
	}

	/// A `renamed:` string argument, e.g. `renamed: "newName"`.
	static func renamed(_ value: String) -> Self {
		.labeledString(.renamed, value: value)
	}
}

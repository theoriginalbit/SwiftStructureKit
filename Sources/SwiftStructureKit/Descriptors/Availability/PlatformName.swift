//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public enum PlatformName: String, Hashable, Sendable {
	case iOS
	case iOSApplicationExtension
	case macOS
	case macOSApplicationExtension
	case macCatalyst
	case macCatalystApplicationExtension
	case watchOS
	case watchOSApplicationExtension
	case tvOS
	case tvOSApplicationExtension
	case visionOS
	case visionOSApplicationExtension
}

public extension PlatformName {
	var value: String {
		rawValue
	}
}

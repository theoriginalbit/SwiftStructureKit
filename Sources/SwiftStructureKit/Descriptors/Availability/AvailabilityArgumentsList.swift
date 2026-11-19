//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public typealias AvailabilityArgumentsList = NonEmptyList<AvailabilityArgumentDescriptor>

public extension AvailabilityArgumentsList {
	init(
		iOS: PlatformVersion,
		macOS: PlatformVersion? = nil,
		macCatalyst: PlatformVersion? = nil,
		watchOS: PlatformVersion? = nil,
		tvOS: PlatformVersion? = nil,
		visionOS: PlatformVersion? = nil,
	) {
		elements = Array<AvailabilityArgumentDescriptor> {
			.iOS(iOS)
			if let macOS { .macOS(macOS) }
			if let macCatalyst { .macCatalyst(macCatalyst) }
			if let watchOS { .watchOS(watchOS) }
			if let tvOS { .tvOS(tvOS) }
			if let visionOS { .visionOS(visionOS) }
			AvailabilityArgumentDescriptor.wildcard
		}
	}

	init(
		macOS: PlatformVersion,
		iOS: PlatformVersion? = nil,
		macCatalyst: PlatformVersion? = nil,
		watchOS: PlatformVersion? = nil,
		tvOS: PlatformVersion? = nil,
		visionOS: PlatformVersion? = nil,
	) {
		elements = Array<AvailabilityArgumentDescriptor> {
			if let iOS { .iOS(iOS) }
			.macOS(macOS)
			if let macCatalyst { .macCatalyst(macCatalyst) }
			if let watchOS { .watchOS(watchOS) }
			if let tvOS { .tvOS(tvOS) }
			if let visionOS { .visionOS(visionOS) }
			AvailabilityArgumentDescriptor.wildcard
		}
	}

	init(
		macCatalyst: PlatformVersion,
		iOS: PlatformVersion? = nil,
		macOS: PlatformVersion? = nil,
		watchOS: PlatformVersion? = nil,
		tvOS: PlatformVersion? = nil,
		visionOS: PlatformVersion? = nil,
	) {
		elements = Array<AvailabilityArgumentDescriptor> {
			if let iOS { .iOS(iOS) }
			if let macOS { .macOS(macOS) }
			.macCatalyst(macCatalyst)
			if let watchOS { .watchOS(watchOS) }
			if let tvOS { .tvOS(tvOS) }
			if let visionOS { .visionOS(visionOS) }
			AvailabilityArgumentDescriptor.wildcard
		}
	}

	init(
		watchOS: PlatformVersion,
		iOS: PlatformVersion? = nil,
		macOS: PlatformVersion? = nil,
		macCatalyst: PlatformVersion? = nil,
		tvOS: PlatformVersion? = nil,
		visionOS: PlatformVersion? = nil,
	) {
		elements = Array<AvailabilityArgumentDescriptor> {
			if let iOS { .iOS(iOS) }
			if let macOS { .macOS(macOS) }
			if let macCatalyst { .macCatalyst(macCatalyst) }
			.watchOS(watchOS)
			if let tvOS { .tvOS(tvOS) }
			if let visionOS { .visionOS(visionOS) }
			AvailabilityArgumentDescriptor.wildcard
		}
	}

	init(
		tvOS: PlatformVersion,
		iOS: PlatformVersion? = nil,
		macOS: PlatformVersion? = nil,
		macCatalyst: PlatformVersion? = nil,
		watchOS: PlatformVersion? = nil,
		visionOS: PlatformVersion? = nil,
	) {
		elements = Array<AvailabilityArgumentDescriptor> {
			if let iOS { .iOS(iOS) }
			if let macOS { .macOS(macOS) }
			if let macCatalyst { .macCatalyst(macCatalyst) }
			if let watchOS { .watchOS(watchOS) }
			.tvOS(tvOS)
			if let visionOS { .visionOS(visionOS) }
			AvailabilityArgumentDescriptor.wildcard
		}
	}

	init(
		visionOS: PlatformVersion,
		iOS: PlatformVersion? = nil,
		macOS: PlatformVersion? = nil,
		macCatalyst: PlatformVersion? = nil,
		watchOS: PlatformVersion? = nil,
		tvOS: PlatformVersion? = nil,
	) {
		elements = Array<AvailabilityArgumentDescriptor> {
			if let iOS { .iOS(iOS) }
			if let macOS { .macOS(macOS) }
			if let macCatalyst { .macCatalyst(macCatalyst) }
			if let watchOS { .watchOS(watchOS) }
			if let tvOS { .tvOS(tvOS) }
			.visionOS(visionOS)
			AvailabilityArgumentDescriptor.wildcard
		}
	}
}

//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

public struct PlatformVersion: Hashable, Sendable {
	public let value: String

	public init?(parsing string: String) {
		// Note: UInt("+1") will return 1, but that's ok.
		let parts = string.split(separator: ".").compactMap { UInt($0) }
		switch parts.count {
		case 1: self.init(parts[0])
		case 2: self.init(parts[0], parts[1])
		case 3: self.init(parts[0], parts[1], parts[2])
		default: return nil
		}
	}

	public init(_ major: UInt) {
		self.value = "\(major)"
	}

	public init(_ major: UInt, _ minor: UInt) {
		self.value = "\(major).\(minor)"
	}

	public init(_ major: UInt, _ minor: UInt, _ patch: UInt) {
		self.value = "\(major).\(minor).\(patch)"
	}
}

extension PlatformVersion: ExpressibleByFloatLiteral {
	public init(floatLiteral value: Double) {
		self.value = String(value)
	}
}

extension PlatformVersion: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: UInt) {
		self.init(value)
	}
}

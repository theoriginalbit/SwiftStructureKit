//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

public protocol ConvertibleToData {
	func convertToData() -> Data
}

extension Data: ConvertibleToData {
	public func convertToData() -> Data { self }
}

extension String: ConvertibleToData {
	public func convertToData() -> Data { Data(utf8) }
}

public protocol ConvertibleToString {
	func convertToString() -> String
}

extension Data: ConvertibleToString {
	public func convertToString() -> String { String(decoding: self, as: UTF8.self) }
}

extension String: ConvertibleToString {
	public func convertToString() -> String { self }
}

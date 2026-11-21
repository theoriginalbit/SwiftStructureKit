//
// Copyright © 2026 SwiftStructureKit. All rights reserved.
//

import Foundation

enum TempDir {
	/// Creates a temporary directory.
	///
	/// To ensure cleanup of the temporary directory, make sure you have the following line
	/// directly after it's creation.
	/// ```swift
	/// defer { try? FileManager.default.removeItem(at: directory) }
	/// ```
	static func create(_ fileManager: FileManager = .default) throws -> URL {
		let tempDir = fileManager.temporaryDirectory.appending(path: UUID().uuidString, directoryHint: .isDirectory)
		try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
		return tempDir
	}
}

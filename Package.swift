// swift-tools-version: 6.1
import PackageDescription

let package = Package(
	name: "SwiftStructureKit",
	platforms: [
		.macOS(.v12),
	],
	products: [
		.library(
			name: "SwiftStructureKit",
			targets: ["SwiftStructureKit"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.7.3")),
	],
	targets: [
		.target(
			name: "SwiftStructureKit",
			dependencies: [
				.product(name: "OrderedCollections", package: "swift-collections"),
			],
		),
		.testTarget(
			name: "SwiftStructureKitTests",
			dependencies: [
				.target(name: "SwiftStructureKit"),
			],
			resources: [
				.copy("Resources"),
			],
		),
	]
)

for target in package.targets {
	var swiftSettings = target.swiftSettings ?? []
	swiftSettings.append(.enableUpcomingFeature("ApproachableConcurrency"))
	target.swiftSettings = swiftSettings
}

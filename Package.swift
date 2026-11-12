// swift-tools-version: 6.1
import PackageDescription

let package = Package(
	name: "SwiftStructureKit",
	platforms: [
		.macOS(.v13),
	],
	products: [
		.library(
			name: "SwiftStructureKit",
			targets: ["SwiftStructureKit"]
		),
		.library(
			name: "SwiftStructureKitTestSupport",
			targets: ["SwiftStructureKitTestSupport"],
		),
	],
	targets: [
		.target(name: "SwiftStructureKit"),
		.target(name: "SwiftStructureKitTestSupport"),
		.testTarget(
			name: "SwiftStructureKitTests",
			dependencies: [
				.target(name: "SwiftStructureKit"),
				.target(name: "SwiftStructureKitTestSupport"),
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

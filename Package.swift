// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftStructureKit",
    products: [
        .library(
            name: "SwiftStructureKit",
            targets: ["SwiftStructureKit"]
        ),
    ],
    targets: [
        .target(name: "SwiftStructureKit"),
        .testTarget(
            name: "SwiftStructureKitTests",
            dependencies: [
				.target(name: "SwiftStructureKit"),
			],
        ),
    ]
)

for target in package.targets {
	var swiftSettings = target.swiftSettings ?? []
	swiftSettings.append(.enableUpcomingFeature("ApproachableConcurrency"))
	target.swiftSettings = swiftSettings
}

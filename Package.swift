// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "BuyMeCoffee",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "BuyMeCoffee",
            targets: ["BuyMeCoffee"],
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.19.2",
        ),
    ],
    targets: [
        .target(
            name: "BuyMeCoffee",
            dependencies: [],
        ),
        .testTarget(
            name: "BuyMeCoffeeTests",
            dependencies: ["BuyMeCoffee"],
        ),
        .testTarget(
            name: "BuyMeCoffeeSnapshotTests",
            dependencies: [
                "BuyMeCoffee",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            resources: [
                .process("__Snapshots__/"),
            ],
        ),
    ]
)

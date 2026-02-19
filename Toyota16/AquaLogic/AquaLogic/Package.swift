// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "AquaLogic",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AquaLogic",
            type: .static,
            targets: ["AquaLogic"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AquaLogic",
            dependencies: []),
    ]
)

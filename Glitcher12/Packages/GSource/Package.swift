// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "GSource",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "GSource",
            type: .static,
            targets: ["GSource"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GSource",
            dependencies: []),
    ]
)

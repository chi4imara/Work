// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "LibSync",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "LibSync",
            type: .static,
            targets: ["LibSync"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LibSync",
            dependencies: []),
    ]
)

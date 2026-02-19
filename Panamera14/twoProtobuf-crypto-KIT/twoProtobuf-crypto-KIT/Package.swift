// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "twoProtobuf-crypto-KIT",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "twoProtobuf-crypto-KIT",
            type: .static,
            targets: ["twoProtobuf-crypto-KIT"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "twoProtobuf-crypto-KIT",
            dependencies: []),
    ]
)

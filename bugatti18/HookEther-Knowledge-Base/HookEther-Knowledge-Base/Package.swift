// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "HookEther-Knowledge-Base",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "HookEther-Knowledge-Base",
            type: .static,
            targets: ["HookEther-Knowledge-Base"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HookEther-Knowledge-Base",
            dependencies: []),
    ]
)

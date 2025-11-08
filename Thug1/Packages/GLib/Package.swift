// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "GLib",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "GLib",
            type: .static,
            targets: ["GLib"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GLib",
            dependencies: []),
    ]
)

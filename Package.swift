// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GreenAlert",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13)
    ],
    products: [
        // ✅ GreenAlert
        .library(
            name: "GreenAlert",
            targets: ["GreenAlert"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JacobSyndeo/SafeSubscripts", from: "1.0.0"),
        .package(url: "https://github.com/JacobSyndeo/Soccer", from: "1.0.0"),
        .package(url: "https://github.com/themomax/swift-docc-plugin", branch: "add-extended-types-flag")
    ],
    targets: [
        // ✅ GreenAlert
        .target(
            name: "GreenAlert",
            dependencies: ["SafeSubscripts", "Soccer"],
            swiftSettings: [.unsafeFlags(["-emit-extension-block-symbols"])]),
        .testTarget(
            name: "GreenAlertTests",
            dependencies: ["GreenAlert"]),
    ]
)

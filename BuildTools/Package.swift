// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_11)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.41.2"),
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.43.1"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)

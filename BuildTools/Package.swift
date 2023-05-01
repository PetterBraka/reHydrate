// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/Realm/SwiftLint", .upToNextMajor(from: .init(0, 43, 1))),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", .upToNextMajor(from: .init(0, 41, 2))),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)

// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationWatchKit",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "PresentationWatchKit",
            targets: ["PresentationWatchKit"]
        )
    ],
    dependencies: [
        .package(path: "../EngineKit"),
        .package(path: "../TestHelper"),
        .package(url: "git@github.com:PetterBraka/LoggingKit.git", exact: "1.2.0"),
    ],
    targets: [
        .target(
            name: "PresentationWatchKit",
            dependencies: [
                "PresentationWatchInterface",
                .product(name: "WatchEngine", package: "EngineKit"),
            ],
            path: "Sources"
        ),
        .target(
            name: "PresentationWatchInterface",
            dependencies: [
                .product(name: "LoggingKit", package: "LoggingKit"),
            ],
            path: "Interface"
        ),
        .testTarget(
            name: "PresentationWatchKitTests",
            dependencies: [
                "TestHelper",
                "PresentationWatchKit",
                .product(name: "EngineMocks", package: "EngineKit"),
            ],
            path: "Tests"
        ),
    ]
)

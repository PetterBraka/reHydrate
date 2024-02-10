// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationWatchKit",
    platforms: [
        .watchOS(.v10), 
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "PresentationWatchKit",
            targets: ["PresentationWatchKit", "PresentationWatchInterface"]
        ),
    ],
    dependencies: [
        .package(path: "../EngineKit"),
    ],
    targets: [
        .target(
            name: "PresentationWatchKit",
            dependencies: [
                "PresentationWatchInterface",
                "EngineKit"
            ]
        ),
        .target(
            name: "PresentationWatchInterface"
        ),
        .testTarget(
            name: "PresentationWatchKitTests",
            dependencies: ["PresentationWatchKit"]),
    ]
)

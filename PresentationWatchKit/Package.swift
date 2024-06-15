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
            targets: ["PresentationWatchKit", "PresentationWatchInterface"]
        ),
    ],
    dependencies: [
        .package(path: "../EngineKit"),
        .package(path: "../CommunicationKit"),
    ],
    targets: [
        .target(
            name: "PresentationWatchKit",
            dependencies: [
                "EngineKit",
                "PresentationWatchInterface",
                "CommunicationKit",
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

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
        .package(path: "../TestHelper")
    ],
    targets: [
        .target(
            name: "PresentationWatchKit",
            dependencies: [
                "PresentationWatchInterface",
                "CommunicationKit",
                .product(name: "WatchEngineKit", package: "EngineKit"),
            ]
        ),
        .target(
            name: "PresentationWatchInterface"
        ),
        .testTarget(
            name: "PresentationWatchKitTests",
            dependencies: [
                "TestHelper",
                "PresentationWatchKit",
                .product(name: "EngineMocks", package: "EngineKit"),
                .product(name: "CommunicationKitMock", package: "CommunicationKit")
            ]),
    ]
)

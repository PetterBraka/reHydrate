// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationWidgetKit",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "PresentationWidgetKit",
            targets: ["PresentationWidgetKit"]
        )
    ],
    dependencies: [
        .package(path: "../EngineKit"),
        .package(path: "../TestHelper"),
        .package(url: "git@github.com:PetterBraka/LoggingKit.git", exact: "1.1.0"),
    ],
    targets: [
        .target(
            name: "PresentationWidgetKit",
            dependencies: [
                "PresentationWidgetKitInterface",
                .product(name: "WidgetEngine", package: "EngineKit"),
            ],
            path: "Sources"
        ),
        .target(
            name: "PresentationWidgetKitInterface",
            dependencies: [
                .product(name: "LoggingKit", package: "LoggingKit"),
            ],
            path: "Interface"
        ),
        .testTarget(
            name: "PresentationWidgetKitTests",
            dependencies: [
                "PresentationWidgetKit",
                "TestHelper",
                .product(name: "EngineMocks", package: "EngineKit"),
            ]
        ),
    ]
)

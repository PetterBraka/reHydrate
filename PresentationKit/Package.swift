// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    Package(
        name: "PresentationKit",
        platforms: [
            .iOS(.v17),
            .macOS(.v14)
        ],
        products: [
            .library(
                name: "PresentationKit",
                targets: ["PresentationKit", "PresentationInterface"]
            ),
        ],
        dependencies: [
            .package(path: "../EngineKit"),
            .package(name: "TestHelper", path: "../TestHelper"),
            .package(url: "git@github.com:PetterBraka/LoggingKit.git", exact: "1.2.0"),
        ],
        targets: [
            .target(
                name: "PresentationKit",
                dependencies: [
                    "PresentationInterface",
                    .product(name: "EngineKit", package: "EngineKit"),
                ],
                path: "Source"
            ),
            .target(
                name: "PresentationInterface",
                dependencies: [
                    .product(name: "LoggingKit", package: "LoggingKit"),
                ],
                path: "Interface"
            ),
            .testTarget(
                name: "PresentationTests",
                dependencies: [
                    "PresentationKit",
                    "TestHelper",
                    .product(name: "EngineMocks", package: "EngineKit")
                ],
                path: "Tests"
            )
        ]
    )
}()

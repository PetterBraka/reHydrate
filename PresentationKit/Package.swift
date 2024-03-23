// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    Package(
        name: "PresentationKit",
        platforms: [
            .iOS(.v17),
            .macOS(.v13)
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
        ],
        targets: [
            .target(
                name: "PresentationKit",
                dependencies: [
                    "PresentationInterface",
                    "EngineKit",
                ]
            ),
            .target(
                name: "PresentationInterface"
            ),
            .testTarget(
                name: "PresentationTests",
                dependencies: [
                    "PresentationKit",
                    "TestHelper",
                ]
            )
        ]
    )
}()

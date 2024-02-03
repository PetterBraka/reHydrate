// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    Package(
        name: "PresentationKit",
        platforms: [.macOS(.v13), .iOS(.v17)],
        products: [
            .library(
                name: "PresentationKit",
                targets: ["PresentationKit", "PresentationInterface"]
            ),
        ],
        dependencies: [
            .package(path: "../EngineKit"),
        ],
        targets: [
            .target(
                name: "PresentationKit",
                dependencies: [
                    "EngineKit",
                    "PresentationInterface"
                ]
            ),
            .target(
                name: "PresentationInterface"
            ),
        ]
    )
}()

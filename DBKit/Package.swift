// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DBKit",
    platforms: [
        .iOS(.v16),
        .watchOS(.v10),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "DBKit",
            targets: ["DBKit", "DBKitMocks"]
        )
    ],
    targets: [
        .target(
            name: "DBKit",
            dependencies: ["DBKitInterface"],
            path: "Source"
        ),
        .target(
            name: "DBKitInterface",
            path: "Interface"
        ),
        .target(
            name: "DBKitMocks",
            dependencies: ["DBKitInterface"],
            path: "Mocks"
        ),
        .testTarget(
            name: "DBKitTests",
            dependencies: ["DBKit", "DBKitMocks"],
            path: "Tests"
        ),
    ]
)

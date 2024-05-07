// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommunicationKit",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "WatchCommunicationKit",
            targets: [
                "WatchCommunicationKit",
                "WatchCommunicationKitInterface",
            ]
        ),
        .library(
            name: "WatchCommunicationKitMock",
            targets: ["WatchCommunicationKitMock"]
        ),
    ],
    targets: [
        .target(
            name: "WatchCommunicationKit",
            dependencies: ["WatchCommunicationKitInterface"],
            path: "Sources/WatchCommunicationKit/Source"
        ),
        .target(
            name: "WatchCommunicationKitInterface",
            path: "Sources/WatchCommunicationKit/Interface"
        ),
        .target(
            name: "WatchCommunicationKitMock",
            dependencies: ["WatchCommunicationKitInterface"],
            path: "Sources/WatchCommunicationKit/Mocks"
        ),
    ]
)

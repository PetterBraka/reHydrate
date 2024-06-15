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
            name: "CommunicationKit",
            targets: [
                "CommunicationKit",
                "CommunicationKitInterface",
            ]
        ),
        .library(
            name: "CommunicationKitMock",
            targets: ["CommunicationKitMock"]
        ),
    ],
    targets: [
        .target(
            name: "CommunicationKit",
            dependencies: ["CommunicationKitInterface"],
            path: "Sources/CommunicationKit/Source"
        ),
        .target(
            name: "CommunicationKitInterface",
            path: "Sources/CommunicationKit/Interface"
        ),
        .target(
            name: "CommunicationKitMock",
            dependencies: ["CommunicationKitInterface"],
            path: "Sources/CommunicationKit/Mocks"
        ),
    ]
)

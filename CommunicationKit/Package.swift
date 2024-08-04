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
            name: "CommunicationSource",
            targets: ["CommunicationKit"]
        ),
        .library(
            name: "CommunicationInterface",
            targets: ["CommunicationKitInterface", "CommunicationKitMocks"]
        ),
        .library(
            name: "CommunicationMocks",
            targets: ["CommunicationKitMocks"]
        ),
    ],
    targets: [
        .target(
            name: "CommunicationKit",
            dependencies: ["CommunicationKitInterface"],
            path: "Sources"
        ),
        .target(
            name: "CommunicationKitInterface",
            path: "Interface"
        ),
        .target(
            name: "CommunicationKitMocks",
            dependencies: ["CommunicationKitInterface"],
            path: "Mocks"
        ),
    ]
)

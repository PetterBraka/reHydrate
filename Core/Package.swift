// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Data", targets: ["Data"]),
        .library(name: "DataInterface", targets: ["DataInterface"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "DomainInterface", targets: ["DomainInterface"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Data",
                dependencies: ["DataInterface"],
                path: "Sources/Data/Source"),
        .target(name: "DataInterface",
                dependencies: [],
                path: "Sources/Data/Interface"),
        .testTarget(name: "DataTests",
                    dependencies: ["Data"],
                    path: "Sources/Data/Tests"),
        
        .target(name: "Domain",
                dependencies: ["Data", "DomainInterface"],
                path: "Sources/Domain/Source"),
        .target(name: "DomainInterface",
                dependencies: [],
                path: "Sources/Domain/Interface"),
        .target(name: "DomainMocks",
                dependencies: [
                    "Domain", "DomainInterface"
                ],
                path: "Sources/Domain/Mocks"),
        .testTarget(name: "DomainTests",
                    dependencies: ["Domain", "DomainMocks"],
                    path: "Sources/Domain/Tests"),
    ]
)

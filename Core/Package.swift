// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "CoreKit", targets: ["CoreKit"]),
        .library(name: "CoreInterfaceKit", targets: ["CoreInterfaceKit"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "CoreKit",
                dependencies: ["CoreInterfaceKit"],
                path: "Sources/CoreKit"),
        .target(name: "CoreInterfaceKit", path: "Sources/CoreInterfaceKit"),
        .testTarget(name: "CoreTests",
                    dependencies: ["CoreKit"],
                    path: "Sources/Tests"),
    ]
)

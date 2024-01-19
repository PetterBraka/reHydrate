// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    // MARK: External dependencies
    let presentationInterface = "PresentationInterface"
    let engineKit = "EngineKit"
    
    // MARK: Packages
    let presentationKit = "PresentationKit"
    
    return Package(
        name: presentationKit,
        platforms: [.macOS(.v13), .iOS(.v17)],
        products: [
            .library(name: presentationKit, targets: [presentationKit]),
        ],
        dependencies: [
            .package(path: "../\(engineKit)"),
            .package(path: "../\(presentationInterface)")
        ],
        targets: [
            .target(
                name: presentationKit,
                dependencies: [
                    .byName(name: engineKit),
                    .byName(name: presentationInterface)
                ]
            ),
        ]
    )
}()

// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    let rootPackage = "PresentationInterface"
    
    let home = "HomePresentationInterface"
    let settings = "SettingsPresentationInterface"
    let editContainer = "EditContainerPresentationInterface"

    return Package(
        name: rootPackage,
        platforms: [
            .iOS(.v16),
        ],
        products: [
            .library(
                name: rootPackage,
                targets: [rootPackage]
            ),
        ],
        dependencies: [],
        targets: [
            .target(
                name: rootPackage,
                dependencies: [
                    .byName(name: home),
                    .byName(name: settings),
                    .byName(name: editContainer)
                ]
            ),
            .target(name: home),
            .target(name: settings),
            .target(name: editContainer),
        ]
    )
}()

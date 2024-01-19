// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    let rootPackage = "PresentationInterface"
    
    let home = "HomePresentationInterface"
    let settings = "SettingsPresentationInterface"
    let editContainer = "EditContainerPresentationInterface"
    let credits = "CreditsPresentationInterface"
    let appIcon = "AppIconPresentationInterface"
    let history = "HistoryPresentationInterface"

    return Package(
        name: rootPackage,
        platforms: [
            .iOS(.v17),
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
                    .byName(name: editContainer),
                    .byName(name: credits),
                    .byName(name: appIcon),
                    .byName(name: history)
                ]
            ),
            .target(name: home),
            .target(name: settings),
            .target(name: editContainer),
            .target(name: credits),
            .target(name: appIcon),
            .target(name: history)
        ]
    )
}()

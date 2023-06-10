// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    // MARK: External dependencies

    let presentationInterface = "PresentationInterface"

    // MARK: Packages

    let engineKit = "EngineKit"
    let presentation = "Presentation"

    let dayService = "DayService"

    return Package(
        name: engineKit,
        platforms: [
            .iOS(.v16),
        ],
        products: [.library(name: engineKit, targets: [engineKit])],
        dependencies: [.package(path: "../\(presentationInterface)")],
        targets: [
            .target(name: engineKit, dependencies: []),
            .target(name: presentation,
                    dependencies: [
                        .byName(name: presentationInterface),
                        .byName(name: dayService),
                    ]),
        ] +
            .targets(forPackage: dayService)
    )
}()

extension Array where Element == Target {
    static func targets(
        forPackage packageName: String,
        sourceDependancy: [Target.Dependency] = [],
        interfaceDependancy: [Target.Dependency] = [],
        mocksDependancy: [Target.Dependency] = [],
        testsDependancy: [Target.Dependency] = []
    ) -> [Target] {
        let rootPath = "Sources/\(packageName)"
        let interfaceName = packageName + "Interface"
        let mocksName = packageName + "Mocks"
        let testsName = packageName + "Tests"

        return [
            .target(name: packageName,
                    dependencies: [.byName(name: interfaceName)] + sourceDependancy,
                    path: rootPath + "/Sources"),
            .target(name: interfaceName,
                    dependencies: interfaceDependancy,
                    path: rootPath + "/Interface"),
            .target(name: mocksName,
                    dependencies: [.byName(name: interfaceName)] + mocksDependancy,
                    path: rootPath + "/Mocks"),
            .testTarget(name: testsName,
                        dependencies: [.byName(name: packageName), .byName(name: mocksName)] + testsDependancy,
                        path: rootPath + "/Tests"),
        ]
    }
}

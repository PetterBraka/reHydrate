// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    // MARK: External dependencies
    let presentationInterface = "PresentationInterface"
    let blackbird = "Blackbird"

    // MARK: Packages
    let engineKit = "EngineKit"

    return Package(
        name: engineKit,
        platforms: [
            .iOS(.v16),
            .macOS(.v13)
        ],
        products: [
            .library(name: engineKit, targets: [engineKit]),
        ],
        dependencies: [
            .blackbird
        ],
        targets: [
            .target(name: engineKit,
                    dependencies: [
                        .source(.dayService),
                        .source(.drinkService),
                        .source(.languageService),
                        .source(.databaseService)
                    ]),
            .target(name: "TestHelper")
        ]
            .with(targetsFrom: .dayService,
                  interfaceDependancy: [.interface(.drinkService)])
            .with(targetsFrom: .drinkService)
            .with(targetsFrom: .languageService)
            .with(targetsFrom: .databaseService,
                  sourceDependancy: [.blackbird],
                  interfaceDependancy: [.blackbird])
    )
}()

enum Feature: String {
    case dayService = "DayService"
    case drinkService = "DrinkService"
    case languageService = "LanguageService"
    case databaseService = "DatabaseService"
}

extension Feature {
    var source: String {
        rawValue
    }
    
    var interface: String {
        rawValue + "Interface"
    }
    
    var mocks: String {
        rawValue + "Mocks"
    }
    
    var tests: String {
        rawValue + "Tests"
    }
}

extension Package.Dependency {
    static let blackbird: Package.Dependency = .package(
        url: "https://github.com/marcoarment/Blackbird.git",
        exact: .init(0, 5, 0)
    )
}

extension Target.Dependency {
    static let blackbird: Target.Dependency = .byName(name: "Blackbird")
    
    static func source(_ feature: Feature) -> Target.Dependency {
        .byName(name: feature.source)
    }
    
    static func interface(_ feature: Feature) -> Target.Dependency {
        .byName(name: feature.interface)
    }
    
    static func mocks(_ feature: Feature) -> Target.Dependency {
        .byName(name: feature.mocks)
    }
    
    static func tests(_ feature: Feature) -> Target.Dependency {
        .byName(name: feature.tests)
    }
}

extension Array where Element == Target {
    func with(
        targetsFrom feature: Feature,
        sourceDependancy: [Target.Dependency] = [],
        interfaceDependancy: [Target.Dependency] = [],
        mocksDependancy: [Target.Dependency] = [],
        testsDependancy: [Target.Dependency] = []
    ) -> [Target] {
        let rootPath = "Sources/\(feature.source)"

        let newTargets: [Target] = [
            .target(name: feature.source,
                    dependencies: [.byName(name: feature.interface)] + sourceDependancy,
                    path: rootPath + "/Sources"),
            .target(name: feature.interface,
                    dependencies: interfaceDependancy,
                    path: rootPath + "/Interface"),
            .target(name: feature.mocks,
                    dependencies: [.byName(name: feature.interface)] + mocksDependancy,
                    path: rootPath + "/Mocks"),
            .testTarget(name: feature.tests,
                        dependencies: [.byName(name: feature.source),
                                       .byName(name: feature.mocks),
                                       .byName(name: "TestHelper")] + testsDependancy,
                        path: rootPath + "/Tests"),
        ]
        return self + newTargets
    }
}

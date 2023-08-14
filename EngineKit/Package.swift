// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    // MARK: Packages
    let engineKit = "EngineKit"
    let engineMocks = "EngineMocks"

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
            .target(name: engineMocks,
                    dependencies: [
                        .mocks(.dayService),
                        .mocks(.drinkService),
                        .mocks(.languageService),
                        .mocks(.databaseService),
                    ]
                   ),
            .testHelper
        ]
            .with(targetsFrom: .dayService,
                  sourceDependancy: [.source(.databaseService)],
                  interfaceDependancy: [.interface(.drinkService)])
            .with(targetsFrom: .drinkService)
            .with(targetsFrom: .languageService)
            .with(targetsFrom: .databaseService,
                  interfaceDependancy: [.blackbird])
            .with(targetsFrom: .timelineService,
                  sourceDependancy: [.source(.databaseService)],
                  testsDependancy: [
                    .mocks(.databaseService)
                  ])
    )
}()

extension Package.Dependency {
    static let blackbird: Package.Dependency = .package(
        url: "https://github.com/marcoarment/Blackbird.git",
        .upToNextMajor(from: .init(0, 5, 0))
    )
}

extension Target {
    static let testHelper: Target = .target(name: "TestHelper")
}

extension Target.Dependency {
    static let testHelper: Target.Dependency = .byName(name: "TestHelper")
    static let blackbird: Target.Dependency = .product(name: "Blackbird", package: "Blackbird")
}

enum Feature: String {
    case dayService = "DayService"
    case drinkService = "DrinkService"
    case languageService = "LanguageService"
    case databaseService = "DatabaseService"
    case timelineService = "TimelineService"
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

extension Target.Dependency {
    
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

extension Array where Element == Target.Dependency {
    func sourceAndMocks(_ feature: Feature) -> [Target.Dependency] {
        [
            .byName(name: feature.source),
            .byName(name: feature.mocks)
        ]
    }
}

extension Array where Element == Target {
    func with(
        targetsFrom feature: Feature,
        sourceDependancy: [Target.Dependency] = [],
        sourceResources: [Resource]? = nil,
        interfaceDependancy: [Target.Dependency] = [],
        interfaceResources: [Resource]? = nil,
        mocksDependancy: [Target.Dependency] = [],
        mocksResources: [Resource]? = nil,
        testsDependancy: [Target.Dependency] = [],
        testsResources: [Resource]? = nil
    ) -> [Target] {
        let rootPath = "Sources/\(feature.source)"

        let newTargets: [Target] = [
            .target(name: feature.source,
                    dependencies: [.byName(name: feature.interface)] + sourceDependancy,
                    path: rootPath + "/Sources",
                    resources: sourceResources),
            .target(name: feature.interface,
                    dependencies: interfaceDependancy,
                    path: rootPath + "/Interface",
                    resources: interfaceResources),
            .target(name: feature.mocks,
                    dependencies: [.byName(name: feature.interface)] + mocksDependancy,
                    path: rootPath + "/Mocks",
                    resources: mocksResources),
            .testTarget(name: feature.tests,
                        dependencies: [
                            .byName(name: feature.source),
                            .byName(name: feature.mocks),
                            .testHelper
                        ] + testsDependancy,
                        path: rootPath + "/Tests",
                        resources: testsResources),
        ]
        return self + newTargets
    }
}

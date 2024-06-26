// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    // MARK: Packages
    let engineKit = "EngineKit"
    let engineMocks = "EngineMocks"

    return Package(
        name: engineKit,
        platforms: [
            .iOS(.v17),
            .macOS(.v14),
            .watchOS(.v10)
        ],
        products: [
            .library(name: engineKit, targets: [engineKit]),
        ],
        dependencies: [
            .package(name: "DBKit", path: "../DBKit"),
            .package(name: "TestHelper", path: "../TestHelper")
        ],
        targets: [
            .target(name: engineKit,
                    dependencies: [
                        .loggingService,
                        .portsInterface,
                        .dbKit,
                        .source(.dayService),
                        .source(.drinkService),
                        .source(.languageService),
                        .source(.unitService),
                        .source(.userPreferenceService),
                        .source(.notificationService),
                        .source(.appearanceService),
                        .source(.dateService),
                        .engineMocks,
                        .portsMocks,
                    ]),
            .target(name: engineMocks,
                    dependencies: [
                        .loggingService,
                        .dbKit,
                        .portsMocks,
                        .mocks(.dayService),
                        .mocks(.drinkService),
                        .mocks(.languageService),
                        .mocks(.unitService),
                        .mocks(.userPreferenceService),
                        .mocks(.notificationService),
                        .mocks(.appearanceService),
                        .mocks(.dateService),
                    ]
                   ),
            .loggingService,
            .portsInterface,
            .portsMocks,
        ]
            .with(targetsFrom: .dayService,
                  sourceDependancy: [
                    .interface(.unitService),
                    .interface(.userPreferenceService),
                    .portsInterface,
                    .dbKit
                  ],
                  interfaceDependancy: [
                    .interface(.drinkService)
                  ])
            .with(targetsFrom: .drinkService,
                  sourceDependancy: [
                    .portsInterface,
                    .dbKit,
                    .interface(.unitService),
                    .interface(.userPreferenceService)
                  ])
            .with(targetsFrom: .languageService, sourceDependancy: [
                .interface(.userPreferenceService)
            ])
            .with(targetsFrom: .timelineService,
                  sourceDependancy: [
                    .portsInterface,
                    .dbKit
                  ],
                  testsDependancy: [
                    .portsMocks
                  ])
            .with(targetsFrom: .unitService,
                  sourceDependancy: [
                    .interface(.userPreferenceService)
                  ])
            .with(targetsFrom: .userPreferenceService)
            .with(targetsFrom: .notificationService,
                  sourceDependancy: [
                    .interface(.dayService),
                    .interface(.userPreferenceService)
                  ])
            .with(targetsFrom: .appearanceService,
                  sourceDependancy: [
                    .interface(.userPreferenceService),
                    .portsInterface
                  ])
            .with(targetsFrom: .dateService)
    )
}()

extension Target {
    static let loggingService: Target = .target(name: "LoggingService")
    static let portsInterface: Target = .target(name: "PortsInterface", path: "Sources/Ports/Interface")
    static let portsMocks: Target = .target(name: "PortsMocks", dependencies: [.portsInterface], path: "Sources/Ports/Mocks")
}

extension Target.Dependency {
    static let dbKit: Target.Dependency = .byName(name: "DBKit")
    static let loggingService: Target.Dependency = .byName(name: "LoggingService")
    static let testHelper: Target.Dependency = .byName(name: "TestHelper")
    static let portsInterface: Target.Dependency = .byName(name: "PortsInterface")
    static let portsMocks: Target.Dependency = .byName(name: "PortsMocks")
    
    static let engineMocks: Target.Dependency = .byName(name: "EngineMocks")
    static let blackbird: Target.Dependency = .product(name: "Blackbird",
                                                       package: "Blackbird")
}

enum Feature: String {
    case dayService = "DayService"
    case dateService = "DateService"
    case drinkService = "DrinkService"
    case languageService = "LanguageService"
    case timelineService = "TimelineService"
    case unitService = "UnitService"
    case userPreferenceService = "UserPreferenceService"
    case notificationService = "NotificationService"
    case appearanceService = "AppearanceService"
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
                    dependencies: [
                        .byName(name: feature.interface),
                        .loggingService
                    ] + sourceDependancy,
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
                            .engineMocks,
                            .dbKit,
                            .testHelper,
                        ] + testsDependancy,
                        path: rootPath + "/Tests",
                        resources: testsResources),
        ]
        return self + newTargets
    }
}

// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    Package(
        name: "EngineKit",
        platforms: [
            .iOS(.v17),
            .macOS(.v14),
            .watchOS(.v10)
        ],
        products: [
            .library(name: "EngineKit", targets: ["EngineKit"]),
            .library(name: "EngineMocks", targets: ["EngineMocks"]),
            .library(name: "WidgetEngine", targets: ["WidgetEngine"]),
            .library(name: "WatchEngine", targets: ["WatchEngine"]),
        ],
        dependencies: [
            .package(name: "DBKit", path: "../DBKit"),
            .package(name: "TestHelper", path: "../TestHelper"),
            .package(name: "CommunicationKit", path: "../CommunicationKit"),
            .package(url: "git@github.com:PetterBraka/LoggingKit.git", exact: "1.1.0"),
        ],
        targets: [
            .target(
                name: "EngineKit",
                dependencies: [
                    .loggingService,
                    .portsInterface,
                    .dbKit,
                    .source(.dayService),
                    .source(.drinkService),
                    .source(.languageService),
                    .source(.unitService),
                    .source(.userPreferenceService),
                    .source(.userNotificationService),
                    .source(.appearanceService),
                    .source(.dateService),
                    .source(.phoneComms),
                    .source(.notificationCenterService),
                ]
            ),
            .target(
                name: "WatchEngine",
                dependencies: [
                    .loggingService,
                    .dbKit,
                    .source(.dayService),
                    .source(.drinkService),
                    .source(.languageService),
                    .source(.unitService),
                    .source(.userPreferenceService),
                    .source(.dateService),
                    .source(.watchComms),
                    .source(.notificationCenterService),
                ]
            ),
            .target(
                name: "WidgetEngine",
                dependencies: [
                    .dbKit,
                    .loggingService,
                    .source(.dayService),
                    .source(.dateService),
                    .source(.unitService),
                    .source(.userPreferenceService),
                    .source(.notificationCenterService),
                ]
            ),
            .target(
                name: "EngineMocks",
                    dependencies: [
                        .communicationMocks,
                        .loggingService,
                        .dbKit,
                        .portsMocks,
                        .mocks(.dayService),
                        .mocks(.drinkService),
                        .mocks(.languageService),
                        .mocks(.unitService),
                        .mocks(.userPreferenceService),
                        .mocks(.userNotificationService),
                        .mocks(.appearanceService),
                        .mocks(.dateService),
                        .mocks(.phoneComms),
                        .mocks(.watchComms),
                        .mocks(.notificationCenterService),
                    ]
                   ),
            .loggingService,
            .portsInterface,
            .portsMocks,
        ]
            .with(
                targetsFrom: .dayService,
                sourceDependancy: [
                    .interface(.unitService),
                    .interface(.userPreferenceService),
                    .interface(.dateService),
                    .interface(.notificationCenterService),
                    .portsInterface,
                    .dbKit,
                ],
                interfaceDependancy: [
                    .interface(.drinkService),
                    .interface(.userPreferenceService),
                    .interface(.notificationCenterService),
                ]
            )
            .with(
                targetsFrom: .drinkService,
                sourceDependancy: [
                    .portsInterface,
                    .dbKit,
                    .interface(.unitService),
                    .interface(.userPreferenceService),
                    .interface(.notificationCenterService),
                ],
                interfaceDependancy: [
                    .interface(.notificationCenterService),
                ]
            )
            .with(
                targetsFrom: .languageService,
                sourceDependancy: [
                    .interface(.userPreferenceService)
                ],
                interfaceDependancy: [
                    .interface(.userPreferenceService),
                ]
            )
            .with(
                targetsFrom: .timelineService,
                sourceDependancy: [
                    .portsInterface,
                    .dbKit
                ],
                testsDependancy: [
                    .portsMocks
                ]
            )
            .with(
                targetsFrom: .unitService,
                sourceDependancy: [
                    .interface(.userPreferenceService),
                    .interface(.notificationCenterService),
                ],
                interfaceDependancy: [
                    .interface(.userPreferenceService),
                    .interface(.notificationCenterService),
                ]
            )
            .with(
                targetsFrom: .userPreferenceService
            )
            .with(
                targetsFrom: .userNotificationService,
                sourceDependancy: [
                    .interface(.dayService),
                    .interface(.userPreferenceService)
                ],
                interfaceDependancy: [
                    .interface(.userPreferenceService),
                ]
            )
            .with(
                targetsFrom: .appearanceService,
                sourceDependancy: [
                    .interface(.userPreferenceService),
                    .portsInterface
                ],
                interfaceDependancy: [
                    .interface(.userPreferenceService),
                ]
            )
            .with(
                targetsFrom: .dateService
            )
            .with(
                targetsFrom: .phoneComms,
                sourceDependancy: [
                    .communicationInterface,
                    .interface(.dateService),
                    .interface(.dayService),
                    .interface(.drinkService),
                    .interface(.unitService)
                ]
            )
            .with(
                targetsFrom: .watchComms,
                sourceDependancy: [
                    .communicationInterface,
                    .interface(.dateService),
                    .interface(.dayService),
                    .interface(.drinkService),
                    .interface(.unitService)
                ]
            )
            .with(
                targetsFrom: .notificationCenterService
            )
    )
}()

extension Target {
    static let loggingService: Target = .target(name: "LoggingService", dependencies: ["LoggingKit"])
    static let portsInterface: Target = .target(name: "PortsInterface", path: "Sources/Ports/Interface")
    static let portsMocks: Target = .target(name: "PortsMocks", dependencies: [.portsInterface], path: "Sources/Ports/Mocks")
}

extension Target.Dependency {
    static let dbKit: Target.Dependency = .product(name: "DBKit", package: "DBKit")
    static let testHelper: Target.Dependency = .product(name: "TestHelper", package: "TestHelper")
    static let communicationSource: Target.Dependency = .product(name: "CommunicationSource", package: "CommunicationKit")
    static let communicationInterface: Target.Dependency = .product(name: "CommunicationInterface", package: "CommunicationKit")
    static let communicationMocks: Target.Dependency = .product(name: "CommunicationMocks", package: "CommunicationKit")
    
    static let loggingService: Target.Dependency = .byName(name: "LoggingService")
    
    static let portsInterface: Target.Dependency = .byName(name: "PortsInterface")
    static let portsMocks: Target.Dependency = .byName(name: "PortsMocks")
    
    static let engineMocks: Target.Dependency = .byName(name: "EngineMocks")
}

enum Feature: String {
    case dayService = "DayService"
    case dateService = "DateService"
    case drinkService = "DrinkService"
    case languageService = "LanguageService"
    case timelineService = "TimelineService"
    case unitService = "UnitService"
    case userPreferenceService = "UserPreferenceService"
    case userNotificationService = "UserNotificationService"
    case notificationCenterService = "NotificationCenterService"
    case appearanceService = "AppearanceService"
    case phoneComms = "PhoneComms"
    case watchComms = "WatchComms"
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
                    dependencies: [
                        "LoggingKit"
                    ] + interfaceDependancy,
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

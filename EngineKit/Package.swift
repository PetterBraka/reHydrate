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
            .package(url: "git@github.com:PetterBraka/LoggingKit.git", exact: "2.0.0"),
        ],
        targets: [
            .target(
                name: "EngineKit",
                dependencies: [
                    "LoggingService",
                    "PortsInterface",
                    .product(name: "DBKit", package: "DBKit"),
                    "DayService",
                    "DrinkService",
                    "LanguageService",
                    "UnitService",
                    "UserPreferenceService",
                    "UserNotificationService",
                    "AppearanceService",
                    "DateService",
                    "PhoneComms",
                ]
            ),
            .target(
                name: "WatchEngine",
                dependencies: [
                    "LoggingService",
                    .product(name: "DBKit", package: "DBKit"),
                    "DayService",
                    "DrinkService",
                    "LanguageService",
                    "UnitService",
                    "UserPreferenceService",
                    "DateService",
                    "WatchComms",
                ]
            ),
            .target(
                name: "WidgetEngine",
                dependencies: [
                    .product(name: "DBKit", package: "DBKit"),
                    "LoggingService",
                    "DayService",
                    "DateService",
                    "UnitService",
                    "UserPreferenceService",
                ]
            ),
            .target(
                name: "EngineMocks",
                    dependencies: [
                        .product(name: "CommunicationMocks", package: "CommunicationKit"),
                        .product(name: "DBKit", package: "DBKit"),
                        "LoggingService",
                        "PortsMocks",
                        "DayServiceMocks",
                        "DrinkServiceMocks",
                        "LanguageServiceMocks",
                        "UnitServiceMocks",
                        "UserPreferenceServiceMocks",
                        "UserNotificationServiceMocks",
                        "AppearanceServiceMocks",
                        "DateServiceMocks",
                        "PhoneCommsMocks",
                        "WatchCommsMocks",
                    ]
                   ),
            .target(name: "LoggingService", dependencies: ["LoggingKit"]),
            .target(name: "PortsInterface", dependencies: ["LoggingService"], path: "Sources/Ports/Interface"),
            .target(name: "PortsMocks", dependencies: ["PortsInterface"], path: "Sources/Ports/Mocks"),
            // MARK: - DayService
            .target(
                name: "DayService",
                dependencies: [
                    "DayServiceInterface",
                    "LoggingService",
                    "UnitServiceInterface",
                    "UserPreferenceServiceInterface",
                    "DateServiceInterface",
                    "PortsInterface",
                    .product(name: "DBKit", package: "DBKit"),
                ],
                path: "Sources/DayService/Sources"
            ),
            .target(
                name: "DayServiceInterface",
                dependencies: [
                    "LoggingKit",
                    "DrinkServiceInterface",
                    "UserPreferenceServiceInterface",
                ],
                path: "Sources/DayService/Interface"
            ),
            .target(
                name: "DayServiceMocks",
                dependencies: ["DayServiceInterface"],
                path: "Sources/DayService/Mocks"
            ),
            .testTarget(
                name: "DayServiceTests",
                dependencies: [
                    "DayService",
                    "DayServiceMocks",
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                ],
                path: "Sources/DayService/Tests"
            ),
            // MARK: - DrinkService
            .target(
                name: "DrinkService",
                dependencies: [
                    "LoggingService",
                    "DrinkServiceInterface",
                    "PortsInterface",
                    .product(name: "DBKit", package: "DBKit"),
                    "UnitServiceInterface",
                    "UserPreferenceServiceInterface",
                ],
                path: "Sources/DrinkService/Sources"
            ),
            .target(
                name: "DrinkServiceInterface",
                dependencies: [
                    "LoggingKit",
                ],
                path: "Sources/DrinkService/Interface"
            ),
            .target(
                name: "DrinkServiceMocks",
                dependencies: ["DrinkServiceInterface"],
                path: "Sources/DrinkService/Mocks"
            ),
            .testTarget(
                name: "DrinkServiceTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "DrinkService",
                    "DrinkServiceMocks",
                ],
                path: "Sources/DrinkService/Tests"
            ),
            // MARK: - DateService
            .target(
                name: "DateService",
                dependencies: [
                    "LoggingService",
                    "DateServiceInterface",
                ],
                path: "Sources/DateService/Sources"
            ),
            .target(
                name: "DateServiceInterface",
                dependencies: [
                ],
                path: "Sources/DateService/Interface"
            ),
            .target(
                name: "DateServiceMocks",
                dependencies: ["DateServiceInterface"],
                path: "Sources/DateService/Mocks"
            ),
            .testTarget(
                name: "DateServiceTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "DateService",
                    "DateServiceMocks",
                ],
                path: "Sources/DateService/Tests"
            ),
            // MARK: - LanguageService
            .target(
                name: "LanguageService",
                dependencies: [
                    "LoggingService",
                    "LanguageServiceInterface",
                    "UserPreferenceServiceInterface",
                ],
                path: "Sources/LanguageService/Sources"
            ),
            .target(
                name: "LanguageServiceInterface",
                dependencies: [
                    "UserPreferenceServiceInterface",
                ],
                path: "Sources/LanguageService/Interface"
            ),
            .target(
                name: "LanguageServiceMocks",
                dependencies: ["LanguageServiceInterface"],
                path: "Sources/LanguageService/Mocks"
            ),
            .testTarget(
                name: "LanguageServiceTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "LanguageService",
                    "LanguageServiceMocks",
                ],
                path: "Sources/LanguageService/Tests"
            ),
            // MARK: - TimelineService
            .target(
                name: "TimelineService",
                dependencies: [
                    "LoggingService",
                    "TimelineServiceInterface",
                    "PortsInterface",
                    .product(name: "DBKit", package: "DBKit")
                ],
                path: "Sources/TimelineService/Sources"
            ),
            .target(
                name: "TimelineServiceInterface",
                dependencies: [],
                path: "Sources/TimelineService/Interface"
            ),
            .target(
                name: "TimelineServiceMocks",
                dependencies: ["TimelineServiceInterface"],
                path: "Sources/TimelineService/Mocks"
            ),
            .testTarget(
                name: "TimelineServiceTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "TimelineService",
                    "TimelineServiceMocks",
                    "PortsMocks"
                ],
                path: "Sources/TimelineService/Tests"
            ),
            // MARK: - UnitService
            .target(
                name: "UnitService",
                dependencies: [
                    "LoggingService",
                    "UnitServiceInterface",
                    "UserPreferenceServiceInterface",
                ],
                path: "Sources/UnitService/Sources"
            ),
            .target(
                name: "UnitServiceInterface",
                dependencies: [
                    "UserPreferenceServiceInterface",
                ],
                path: "Sources/UnitService/Interface"
            ),
            .target(
                name: "UnitServiceMocks",
                dependencies: ["UnitServiceInterface"],
                path: "Sources/UnitService/Mocks"
            ),
            .testTarget(
                name: "UnitServiceTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "UnitService",
                    "UnitServiceMocks",
                ],
                path: "Sources/UnitService/Tests"
            ),
            // MARK: - UserPreferenceService
            .target(
                name: "UserPreferenceService",
                dependencies: [
                    "LoggingService",
                    "UserPreferenceServiceInterface",
                ],
                path: "Sources/UserPreferenceService/Sources"
            ),
            .target(
                name: "UserPreferenceServiceInterface",
                dependencies: [
                    "LoggingKit",
                ],
                path: "Sources/UserPreferenceService/Interface"
            ),
            .target(
                name: "UserPreferenceServiceMocks",
                dependencies: ["UserPreferenceServiceInterface"],
                path: "Sources/UserPreferenceService/Mocks"
            ),
            .testTarget(
                name: "UserPreferenceServiceTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "UserPreferenceService",
                    "UserPreferenceServiceMocks",
                ],
                path: "Sources/UserPreferenceService/Tests"
            ),
            // MARK: - UserNotificationService
            .target(
                name: "UserNotificationService",
                dependencies: [
                    "LoggingService",
                    "UserNotificationServiceInterface",
                    "DayServiceInterface",
                    "UserPreferenceServiceInterface",
                    "DateServiceInterface",
                ],
                path: "Sources/UserNotificationService/Sources"
            ),
            .target(
                name: "UserNotificationServiceInterface",
                dependencies: [
                    "UserPreferenceServiceInterface",
                ],
                path: "Sources/UserNotificationService/Interface"
            ),
            .target(
                name: "UserNotificationServiceMocks",
                dependencies: ["UserNotificationServiceInterface"],
                path: "Sources/UserNotificationService/Mocks"
            ),
            .testTarget(
                name: "UserNotificationServiceTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "UserNotificationService",
                    "UserNotificationServiceMocks",
                ],
                path: "Sources/UserNotificationService/Tests"
            ),
            // MARK: - AppearanceService
            .target(
                name: "AppearanceService",
                dependencies: [
                    "LoggingService",
                    "AppearanceServiceInterface",
                    "UserPreferenceServiceInterface",
                    "PortsInterface"
                ],
                path: "Sources/AppearanceService/Sources"
            ),
            .target(
                name: "AppearanceServiceInterface",
                dependencies: [
                    "UserPreferenceServiceInterface",
                ],
                path: "Sources/AppearanceService/Interface"
            ),
            .target(
                name: "AppearanceServiceMocks",
                dependencies: ["AppearanceServiceInterface"],
                path: "Sources/AppearanceService/Mocks"
            ),
            .testTarget(
                name: "AppearanceServiceTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "AppearanceService",
                    "AppearanceServiceMocks",
                ],
                path: "Sources/AppearanceService/Tests"
            ),
            // MARK: - PhoneComms
            .target(
                name: "PhoneComms",
                dependencies: [
                    "LoggingService",
                    "PhoneCommsInterface",
                    .product(name: "CommunicationInterface", package: "CommunicationKit"),
                    "DateServiceInterface",
                    "DayServiceInterface",
                    "DrinkServiceInterface",
                    "UnitServiceInterface"
                ],
                path: "Sources/PhoneComms/Sources"
            ),
            .target(
                name: "PhoneCommsInterface",
                dependencies: [
                    "LoggingKit",
                ],
                path: "Sources/PhoneComms/Interface"
            ),
            .target(
                name: "PhoneCommsMocks",
                dependencies: ["PhoneCommsInterface"],
                path: "Sources/PhoneComms/Mocks"
            ),
            .testTarget(
                name: "PhoneCommsTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "PhoneComms",
                    "PhoneCommsMocks",
                ],
                path: "Sources/PhoneComms/Tests"
            ),
            // MARK: - WatchComms
            .target(
                name: "WatchComms",
                dependencies: [
                    "LoggingService",
                    "WatchCommsInterface",
                    .product(name: "CommunicationInterface", package: "CommunicationKit"),
                    "DateServiceInterface",
                    "DayServiceInterface",
                    "DrinkServiceInterface",
                    "UnitServiceInterface"
                ],
                path: "Sources/WatchComms/Sources",
                swiftSettings: [
                    .enableExperimentalFeature("StrictConcurrency")
                ]
            ),
            .target(
                name: "WatchCommsInterface",
                dependencies: [
                    "LoggingKit",
                ],
                path: "Sources/WatchComms/Interface",
                swiftSettings: [
                    .enableExperimentalFeature("StrictConcurrency")
                ]
            ),
            .target(
                name: "WatchCommsMocks",
                dependencies: ["WatchCommsInterface"],
                path: "Sources/WatchComms/Mocks",
                swiftSettings: [
                    .enableExperimentalFeature("StrictConcurrency")
                ]
            ),
            .testTarget(
                name: "WatchCommsTests",
                dependencies: [
                    "EngineMocks",
                    .product(name: "DBKit", package: "DBKit"),
                    .product(name: "TestHelper", package: "TestHelper"),
                    "WatchComms",
                    "WatchCommsMocks",
                ],
                path: "Sources/WatchComms/Tests",
                swiftSettings: [
                    .enableExperimentalFeature("StrictConcurrency")
                ]
            ),
        ]
    )
}()

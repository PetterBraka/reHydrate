// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = {
    // MARK: External dependencies

    let presentationInterface = "PresentationInterface"

    // MARK: Packages

    let engineKit = "EngineKit"
    let presentation = "Presentation"

    let dayService = Feature(withName: "DayService")
    let drinkService = Feature(withName: "DrinkService")

    return Package(
        name: engineKit,
        platforms: [
            .iOS(.v16),
        ],
        products: [
            .library(name: engineKit, targets: [engineKit]),
            .library(name: presentation, targets: [presentation])
        ],
        dependencies: [.package(path: "../\(presentationInterface)")],
        targets: [
            .target(name: engineKit,
                    dependencies: [
                        .byName(name: dayService.source),
                        .byName(name: drinkService.source),
                    ]),
            .target(name: presentation,
                    dependencies: [
                        .byName(name: presentationInterface),
                        .byName(name: dayService.source),
                        .byName(name: drinkService.source),
                    ]),
        ]
            .withTargets(forFeature: dayService,
                         interfaceDependancy: [.byName(name: drinkService.interface)])
            .withTargets(forFeature: drinkService)
    )
}()

struct Feature {
    let source: String
    let interface: String
    let mocks: String
    let tests: String
    
    init(source: String,
         interface: String,
         mocks: String,
         tests: String) {
        self.source = source
        self.interface = interface
        self.mocks = mocks
        self.tests = tests
    }
    
    init(withName name: String) {
        self.source = name
        self.interface = name + "Interface"
        self.mocks = name + "Mocks"
        self.tests = name + "Tests"
    }
}

extension Array where Element == Target {
    func withTargets(
        forFeature feature: Feature,
        sourceDependancy: [Target.Dependency] = [],
        interfaceDependancy: [Target.Dependency] = [],
        mocksDependancy: [Target.Dependency] = [],
        testsDependancy: [Target.Dependency] = []
    ) -> [Target] {
        self + .targets(
            forFeature: feature,
            sourceDependancy: sourceDependancy,
            interfaceDependancy: interfaceDependancy,
            mocksDependancy: mocksDependancy,
            testsDependancy: testsDependancy
        )
    }
    
    static func targets(
        forFeature feature: Feature,
        sourceDependancy: [Target.Dependency] = [],
        interfaceDependancy: [Target.Dependency] = [],
        mocksDependancy: [Target.Dependency] = [],
        testsDependancy: [Target.Dependency] = []
    ) -> [Target] {
        let rootPath = "Sources/\(feature.source)"

        return [
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
                                       .byName(name: feature.mocks)] + testsDependancy,
                        path: rootPath + "/Tests"),
        ]
    }
}

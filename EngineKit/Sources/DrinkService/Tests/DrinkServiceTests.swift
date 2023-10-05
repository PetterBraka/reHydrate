//
//  DrinkServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 17/08/2023.
//

import XCTest
import EngineMocks
import TestHelper
import LoggingService
import UnitServiceInterface
import DatabaseServiceInterface
import DatabaseServiceMocks
import DrinkServiceInterface
@testable import DrinkService

final class DrinkServiceTests: XCTestCase {
    typealias Engine = (
        HasLoggingService &
        HasContainerManagerService &
        HasUnitService
    )
    
    var engine: Engine = EngineMocks()
    
    var containerManager: ContainerManagerType!
    var sut: DrinkServiceType!
    
    override func setUp() {
        self.containerManager = ContainerManagerStub()
        self.engine.containerManager = containerManager
        self.sut = DrinkService(engine: engine)
    }
    
    func test_addDrink() async throws {}
    
    func test_editDrink(editedDrink newDrink: Drink) async throws {}
    
    func test_remove(container: String) async throws {}
    
    func test_getSavedDrinks() async throws {}
    
    func test_resetToDefault() async {}
}

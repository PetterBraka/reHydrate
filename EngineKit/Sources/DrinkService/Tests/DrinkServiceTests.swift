//
//  DrinkServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 17/08/2023.
//

import XCTest
import EngineMocks
import TestHelper
import DatabaseServiceInterface
import DatabaseServiceMocks
import DrinkServiceInterface
@testable import DrinkService

final class DrinkServiceTests: XCTestCase {
    typealias Engine = (
        HasDayManagerService
    )
    
    var engine: Engine = EngineMocks()
    
    var dayManager: DayManagerStub!
    var sut: DrinkServiceType!
    
    override func setUp() {
        self.dayManager = DayManagerStub()
        self.engine.dayManager = dayManager
        self.sut = DrinkService()
    }
    
    func test_addDrink() {
        XCTFail("TODO: implement testing of the Drink service")
    }
}

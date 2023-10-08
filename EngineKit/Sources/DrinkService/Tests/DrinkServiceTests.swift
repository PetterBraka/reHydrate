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
        HasDatabaseService &
        HasLoggingService &
        HasDrinkManagerService &
        HasUnitService
    )
    
    var engine: Engine = EngineMocks()
    
    var drinkManager: DrinkManagerStub!
    var sut: DrinkServiceType!
    
    override func setUp() {
        self.drinkManager = DrinkManagerStub()
        self.engine.drinkManager = drinkManager
        self.sut = DrinkService(engine: engine)
    }
    
    func test_mappingDrink() {
        let givenDrinks = [
            DrinkModel(id: "", size: 300, container: "small"),
            DrinkModel(id: "", size: 500, container: "medium"),
            DrinkModel(id: "", size: 750, container: "large")
        ]
        for givenDrink in givenDrinks {
            XCTAssertNotNil(Drink(from: givenDrink))
        }
    }
    
    func test_mappingDrinkFails() {
        let givenDrinks = [
            DrinkModel(id: "", size: 300, container: "smal"),
            DrinkModel(id: "", size: 500, container: "medum"),
            DrinkModel(id: "", size: 750, container: "lage")
        ]
        for givenDrink in givenDrinks {
            XCTAssertNil(Drink(from: givenDrink))
        }
    }
    
    func test_addDrink() async throws {
        let newDrink = try await sut.addDrink(size: 200, container: .small)
        assert(newDrink, .init(id: "", size: 200, container: .small))
    }
    
    func test_addDrink_givenMappingError() async throws {
        drinkManager.createNewDrink_returnValue = .init(id: "", size: 0, container: "mid")
        do {
            _ = try await sut.addDrink(size: 200, container: .small)
            XCTFail("Should fail")
        } catch {
            // Then
            if let dbError = error as? DrinkDBError {
                XCTAssertEqual(dbError, .creatingDrink)
            } else {
                XCTFail("Unexpected error thrown")
            }
        }
    }
    
    func test_addDrink_givenCreationError() async throws {
        // given
        drinkManager.createNewDrink_returnError = DrinkDBError.creatingDrink
        // When
        do {
            _ = try await sut.addDrink(size: 200, container: .small)
            XCTFail("Should fail")
        } catch {
            // Then
            if let dbError = error as? DrinkDBError {
                XCTAssertEqual(dbError, .creatingDrink)
            } else {
                XCTFail("Unexpected error thrown")
            }
        }
    }
    
    func test_editDrink() async throws {
        let givenDrink = DrinkModel(id: "", size: 500, container: "medium")
        drinkManager.edit_returnValue = .success(givenDrink)
        let unwrappedDrink = try XCTUnwrap(Drink(from: givenDrink))
        let editedDrink = try await sut.editDrink(editedDrink: unwrappedDrink)
        assert(editedDrink, givenDrink)
    }
    
    func test_editDrink_mapping() async throws {
        let givenDrink = DrinkModel(id: "", size: 500, container: "mid")
        drinkManager.edit_returnValue = .success(givenDrink)
        
        do {
            let editedDrink = try await sut.editDrink(editedDrink:
                    .init(id: "", size: 500, container: .medium)
            )
            XCTFail("Should fail")
        } catch {
            // Then
            if let dbError = error as? DrinkDBError {
                XCTAssertEqual(dbError, .notFound)
            } else {
                XCTFail("Unexpected error thrown")
            }
        }
    }
    
    func test_remove() async throws {
        try await sut.remove(container: Container.medium.rawValue)
    }
    
    func test_remove_givenDBisEmpty() async throws {
        drinkManager.deleteDrink_returnError = DrinkDBError.notFound
        do {
            try await sut.remove(container: Container.medium.rawValue)
            XCTFail("Should fail")
        } catch {
            // Then
            if let dbError = error as? DrinkDBError {
                XCTAssertEqual(dbError, .notFound)
            } else {
                XCTFail("Unexpected error thrown")
            }
        }
    }
    
    func test_getSavedDrinks() async throws {
        let givenDrinks = [
            DrinkModel(id: "", size: 100, container: "small"),
            DrinkModel(id: "", size: 200, container: "medium"),
            DrinkModel(id: "", size: 300, container: "large")
        ]
        drinkManager.fetchAll_returnValue = .success(givenDrinks)
        let drinks = try await sut.getSavedDrinks()
        assert(drinks, givenDrinks)
    }
    
    func test_resetToDefault() async {
        let defaults = await sut.resetToDefault()
        assert(defaults, [
            Drink(id: "", size: 300, container: .small),
            Drink(id: "", size: 500, container: .medium),
            Drink(id: "", size: 750, container: .large)
        ])
    }
    
    func test_resetToDefault_whenFailingToStore() async {
        drinkManager.createNewDrink_returnError = DrinkDBError.creatingDrink
        let defaults = await sut.resetToDefault()
        assert(defaults, [
            Drink(id: "", size: 300, container: .small),
            Drink(id: "", size: 500, container: .medium),
            Drink(id: "", size: 750, container: .large)
        ])
    }
}

private extension DrinkServiceTests {
    func assert(_ givenDrink: Drink, _ expectedDrink: Drink,
                file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(givenDrink.size, expectedDrink.size,
                       file: file, line: line)
        XCTAssertEqual(givenDrink.container, expectedDrink.container,
                       file: file, line: line)
    }
    
    func assert(_ givenDrink: Drink, _ expectedDrink: DrinkModel,
                file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(givenDrink.size, expectedDrink.size,
                       file: file, line: line)
        XCTAssertEqual(givenDrink.container.rawValue,
                       expectedDrink.container,
                       file: file, line: line)
    }
    
    func assert(_ givenDrinks: [Drink], _ expectedDrinks: [Drink],
                 file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(givenDrinks.count, expectedDrinks.count,
                       file: file, line: line)
        let givenSize = givenDrinks.map(\.size)
        let givenContainers = givenDrinks.map(\.container)
        let expectedSize = expectedDrinks.map(\.size)
        let expectedContainers = expectedDrinks.map(\.container)
        XCTAssertEqual(givenSize, expectedSize,
                       file: file, line: line)
        XCTAssertEqual(givenContainers, expectedContainers,
                       file: file, line: line)
    }
    
    func assert(_ givenDrinks: [Drink], _ expectedDrinks: [DrinkModel],
                file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(givenDrinks.count, expectedDrinks.count,
                       file: file, line: line)
        let givenSize = givenDrinks.map(\.size)
        let givenContainers = givenDrinks.map(\.container.rawValue)
        let expectedSize = expectedDrinks.map(\.size)
        let expectedContainers = expectedDrinks.map(\.container)
        XCTAssertEqual(givenSize, expectedSize,
                       file: file, line: line)
        XCTAssertEqual(givenContainers, expectedContainers,
                       file: file, line: line)
    }
}

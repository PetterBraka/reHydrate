//
//  ContainerManagerTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 20/08/2023.
//

import XCTest
import TestHelper
@testable import DatabaseService
import DatabaseServiceInterface
import DatabaseServiceMocks

final class ContainerManagerTests: XCTestCase {
    let database = Database()
    var spy: DatabaseSpy<ContainerModel>!
    var sut: ContainerManagerType!
    
    override func setUp() {
        self.spy = DatabaseSpy(realObject: database)
        self.sut = ContainerManager(database: spy)
    }
    
    override func tearDown() async throws {
        try await spy.deleteAll(ContainerModel(id: "-", size: 0))
        let db = try XCTUnwrap(database.db)
        XCTAssertTrue(db.isClosed)
    }
    
    func test_createContainer() async throws {
        let givenSize = 300
        
        let newEntry = try await sut.createEntry(of: givenSize)
        
        XCTAssertEqual(newEntry.size, givenSize)
        XCTAssertEqual(spy.methodLogNames, [.write])
    }
    
    func test_updateContainer() async throws {
        let givenContainer = ContainerModel(id: UUID().uuidString, size: 500)
        
        let updatedContainer = try await sut.update(givenContainer, newSize: 800)
        
        XCTAssertEqual(givenContainer.id, updatedContainer.id)
        XCTAssertNotEqual(givenContainer.size, updatedContainer.size)
        XCTAssertEqual(updatedContainer.size, 800)
        XCTAssertEqual(spy.methodLogNames, [.write])
    }
    
    func test_fetchAll() async throws {
        try await preLoadXEntries(5)
        
        let foundContainers = try await sut.fetchAll()
        
        XCTAssertEqual(foundContainers.count, 5)
        
        for container in foundContainers {
            let index = try XCTUnwrap(foundContainers.firstIndex(of: container))
            let nextIndex = index + 1
            guard nextIndex < foundContainers.count else { return }
            
            let nextContainer = foundContainers[nextIndex]
            XCTAssertTrue(container.size < nextContainer.size)
        }
    }
    
    func test_delete() async throws {
        let preLoadedEntries = try await preLoadXEntries(3)
        let randomEntry = try XCTUnwrap(preLoadedEntries.randomElement())
        try await sut.delete(randomEntry)
        let foundEntries = try await sut.fetchAll()
        
        XCTAssertTrue(preLoadedEntries.contains(randomEntry))
        XCTAssertFalse(foundEntries.contains(randomEntry))
        XCTAssertEqual(foundEntries.count, preLoadedEntries.count - 1)
    }
}

extension ContainerManagerTests {
    @discardableResult
    func preLoadXEntries(
        _ number: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> [ContainerModel] {
        let min = 1
        XCTAssertTrue(number > min)
        var preLoadedEntries = [ContainerModel]()
        for _ in min ... number {
            let givenSize = Int.random(in: 300 ... 1000)
            let newEntry = try await sut.createEntry(of: givenSize)
            preLoadedEntries.append(newEntry)
            XCTAssertEqual(newEntry.size, givenSize, file: file, line: line)
        }
        XCTAssertEqual(preLoadedEntries.count, number, file: file, line: line)
        return preLoadedEntries
    }
}

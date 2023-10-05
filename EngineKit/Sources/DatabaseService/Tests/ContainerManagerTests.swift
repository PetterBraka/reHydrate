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
    let database = Database(logger: .init(subsystem: "ContainerManagerTests"))
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
        
        let newEntry = try await sut.create(size: givenSize)
        
        XCTAssertEqual(newEntry.size, givenSize)
        XCTAssertEqual(spy.methodLogNames, [.write])
    }
    
    func test_updateContainer_withMissingData() async throws {
        let givenSize = 500
        do {
            let container = try await sut.update(oldSize: givenSize, newSize: 800)
            XCTFail("Didn't expect to find container \(container)")
        } catch {
            guard let dbError = error as? DatabaseError else {
                XCTFail("Expected database error not \(error)")
                return
            }
            XCTAssertEqual(dbError, .noElementFound)
        }
        
        XCTAssertEqual(spy.methodLogNames, [.readMatchingOrderByLimit])
    }
    
    func test_updateContainer() async throws {
        let givenSize = 500
        _ = try await sut.create(size: givenSize)
        
        let updatedContainer = try await sut.update(oldSize: givenSize, newSize: 800)
        
        XCTAssertNotEqual(updatedContainer.size, givenSize)
        XCTAssertEqual(updatedContainer.size, 800)
        XCTAssertEqual(spy.methodLogNames, [.write, .readMatchingOrderByLimit, .write])
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
        try await sut.delete(size: randomEntry.size)
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
            let newEntry = try await sut.create(size: givenSize)
            preLoadedEntries.append(newEntry)
            XCTAssertEqual(newEntry.size, givenSize, file: file, line: line)
        }
        XCTAssertEqual(preLoadedEntries.count, number, file: file, line: line)
        return preLoadedEntries
    }
}

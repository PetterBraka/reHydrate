//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/08/2023.
//

import XCTest
@testable import reHydrate
import PortsInterface

final class DatabaseTests: XCTestCase {
    let referenceDate = Date(timeIntervalSince1970: 1688227143)
    
    var spy = DatabaseSpy<DummyModel>(realObject: Database(logger: .init(subsystem: "DatabaseTests")))
    
    override func tearDown() async throws {
        try await spy.deleteAll(DummyModel(text: ""))
        assertDbIsClosed()
        let foundModels = try await spy.read(matching: nil, orderBy: .ascending(\DummyModel.$text), limit: nil)
        assertDbIsClosed()
        XCTAssertTrue(foundModels.isEmpty)
    }
    
    func test_write() async throws {
        let givenModel = DummyModel(text: "dummy")
        try await spy.write(givenModel)
        assertDbIsClosed()
        XCTAssertEqual(spy.varLog, [.db])
        XCTAssertEqual(spy.methodLogNames, [.write])
        XCTAssertEqual(spy.methodLog, [.write(givenModel)])
    }
    
    func test_read() async throws {
        let givenModel = DummyModel(text: "dummy")
        try await spy.write(givenModel)
        assertDbIsClosed()
        
        let foundModels = try await spy.read(matching: nil, orderBy: .ascending(\DummyModel.$text), limit: nil)
        assertDbIsClosed()
        XCTAssertEqual(spy.varLog, [.db, .db])
        XCTAssertEqual(spy.methodLogNames, [.write, .readMatchingOrderByLimit])
        XCTAssertEqual(foundModels, [givenModel])
    }
    
    func test_delete() async throws {
        let givenModel = DummyModel(text: "dummy")
        try await spy.write(givenModel)
        assertDbIsClosed()
        
        try await spy.delete(givenModel)
        assertDbIsClosed()
        
        let foundModels = try await spy.read(matching: nil, orderBy: .ascending(\DummyModel.$text), limit: nil)
        assertDbIsClosed()
        
        XCTAssertEqual(spy.varLog, [.db, .db, .db])
        XCTAssertEqual(spy.methodLogNames, [.write, .delete, .readMatchingOrderByLimit])
        XCTAssertTrue(foundModels.isEmpty)
    }
    
    func test_deleteMatching() async throws {
        let givenModel = DummyModel(text: "dummy")
        try await spy.write(givenModel)
        assertDbIsClosed()
        
        try await spy.delete(matching: .like(\DummyModel.$text, "dummy"))
        assertDbIsClosed()
        
        let foundModels = try await spy.read(matching: nil, orderBy: .ascending(\DummyModel.$text), limit: nil)
        assertDbIsClosed()
        
        XCTAssertEqual(spy.varLog, [.db, .db, .db])
        XCTAssertEqual(spy.methodLogNames, [.write, .deleteMatching, .readMatchingOrderByLimit])
        XCTAssertTrue(foundModels.isEmpty)
    }
}

extension DatabaseTests {
    private func assertDbIsClosed(file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(spy.db?.isClosed ?? false, file: file, line: line)
    }
}

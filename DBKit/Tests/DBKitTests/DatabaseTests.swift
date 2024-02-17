//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/08/2023.
//

import XCTest
@testable import DBKitInterface

//final class DatabaseTests: XCTestCase {
//    let referenceDate = Date(timeIntervalSince1970: 1688227143)
//    
//    var spy: DatabaseSpy<DummyModel>!
//    var context: NSManagedObjectContext!
//    
////    override func tearDown() async throws {
////        assertDbIsClosed()
////        let foundModels = try await spy.read(matching: nil, orderBy: .ascending(\DummyModel.$text), limit: nil)
////        assertDbIsClosed()
////        XCTAssertTrue(foundModels.isEmpty)
////    }
//    
//    override func setUp() async throws {
//        let sut = Database(inMemory: true)
//        spy = DatabaseSpy(realObject: sut)
//        context = spy.open()
//    }
//    
//    func test_create() async throws {
//        let newElement: DummyModel = try spy.create(className: String(describing: DummyModel.self), context)
//        XCTAssertEqual(newElement, DayEntity())
//        XCTAssertEqual(spy.varLog, [])
//        XCTAssertEqual(spy.methodLogNames, [.open, .create])
//        XCTAssertEqual(spy.methodLog, [.create("DayEntity", context)])
//    }
//    
//    func test_read() async throws {
//        let newElement = try spy.create(className: String(describing: DayEntity.self), context)
////        newElement.text = "dummy"
//        spy.save(context)
//        
//        let foundModels: [DummyModel] = try await spy.read(matching: nil, sortBy: nil, limit: nil, context)
//        XCTAssertEqual(spy.varLog, [])
//        XCTAssertEqual(spy.methodLogNames, [.open, .create, .save, .read])
////        XCTAssertEqual(foundModels, [givenModel])
//    }
//    
//    func test_delete() async throws {
//        let givenModel = DummyModel()
//        let newElement = try spy.create(className: String(describing: DayEntity.self), context)
////        newElement.text = "dummy"
//        spy.save(context)
//        
//        try spy.delete(newElement, context)
//        
//        let foundModels: [DummyModel] = try await spy.read(matching: nil, sortBy: nil, limit: nil, context)
//        XCTAssertEqual(spy.varLog, [])
//        XCTAssertEqual(spy.methodLogNames, 
//                       [.open, .create, .save, .delete, .read])
//        XCTAssertEqual(foundModels, [givenModel])
//    }
//}

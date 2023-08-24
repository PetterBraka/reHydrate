//
//  UserPreferenceServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import XCTest
import UserPreferenceServiceInterface
@testable import UserPreferenceService

final class UserPreferenceServiceTests: XCTestCase {
    var defaults: UserDefaults!
    var sut: UserPreferenceServiceType!
    
    override func setUp() {
        self.defaults = UserDefaults(suiteName: #file)
        self.sut = UserPreferenceService(defaults: defaults)
    }
    
    override func tearDown() {
        self.defaults.removePersistentDomain(forName: #file)
    }
    
    func test_setString_success() throws {
        try sut.set("Dummy string", for: "DummyString")
    }
    
    func test_setInt_success() throws {
        try sut.set(123, for: "DummyInt")
    }
    
    func test_setDouble_success() throws {
        try sut.set(123.123, for: "DummyDouble")
    }
    
    func test_setData_success() throws {
        try sut.set("Dummy data".data(using: .utf8)!, for: "DummyData")
    }
    
    func test_getString_success() throws {
        let key = "DummyString"
        let givenValue = "Dummy string"
        try sut.set(givenValue, for: key)
        let foundValue: String? = sut.get(for: key)
        XCTAssertEqual(foundValue, givenValue)
    }
    
    func test_getInt_success() throws {
        let key = "DummyInt"
        let givenValue = 123
        try sut.set(givenValue, for: key)
        let foundValue: Int? = sut.get(for: key)
        XCTAssertEqual(foundValue, givenValue)
    }
    
    func test_getDouble_success() throws {
        let key = "DummyDouble"
        let givenValue = 123.123
        try sut.set(givenValue, for: key)
        let foundValue: Double? = sut.get(for: key)
        XCTAssertEqual(foundValue, givenValue)
    }
    
    func test_getData_success() throws {
        let key = "DummyData"
        let givenValue = "Dummy data".data(using: .utf8)!
        try sut.set(givenValue, for: key)
        let foundValue: Data? = sut.get(for: key)
        XCTAssertEqual(foundValue, givenValue)
    }
}

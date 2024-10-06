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
        try sut.set("Dummy string", for: .dummyString)
    }
    
    func test_setInt_success() throws {
        try sut.set(123, for: .dummyInt)
    }
    
    func test_setDouble_success() throws {
        try sut.set(123.123, for: .dummyDouble)
    }
    
    func test_setData_success() throws {
        try sut.set("Dummy data".data(using: .utf8)!, for: .dummyData)
    }
    
    func test_getString_success() throws {
        let givenValue = "Dummy string"
        try sut.set(givenValue, for: .dummyString)
        let foundValue: String? = sut.get(for: .dummyString)
        XCTAssertEqual(foundValue, givenValue)
    }
    
    func test_getInt_success() throws {
        let givenValue = 123
        try sut.set(givenValue, for: .dummyInt)
        let foundValue: Int? = sut.get(for: .dummyInt)
        XCTAssertEqual(foundValue, givenValue)
    }
    
    func test_getDouble_success() throws {
        let givenValue = 123.123
        try sut.set(givenValue, for: .dummyDouble)
        let foundValue: Double? = sut.get(for: .dummyDouble)
        XCTAssertEqual(foundValue, givenValue)
    }
    
    func test_getData_success() throws {
        let givenValue = "Dummy data".data(using: .utf8)!
        try sut.set(givenValue, for: .dummyData)
        let foundValue: Data? = sut.get(for: .dummyData)
        XCTAssertEqual(foundValue, givenValue)
    }
}

extension PreferenceKey {
    public static let dummyString = PreferenceKey("DummyString")
    public static let dummyInt = PreferenceKey("DummyInt")
    public static let dummyDouble = PreferenceKey("DummyDouble")
    public static let dummyData = PreferenceKey("DummyData")
}

//
//  UnitServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import XCTest
import UnitServiceInterface
import EngineMocks
import UserPreferenceServiceMocks
@testable import UnitService

final class UnitServiceTests: XCTestCase {
    let accuracy: Double = 0.01
    var sut: UnitServiceType!
    var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    
    override func setUp() {
        let engine = EngineMocks()
        userPreferenceService = engine.makeUserPreferenceService()
        self.sut = UnitService(engine: engine)
    }
    
    func test_convertSmallImperialToLargImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .ounces, to: .pint)
        XCTAssertEqual(result, 0.05, accuracy: accuracy)
    }
    
    func test_convertLargeImperialToSmallImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .pint, to: .ounces)
        XCTAssertEqual(result, 20, accuracy: accuracy)
    }
    
    func test_convertSmallImperialToSmallMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .ounces, to: .millilitres)
        XCTAssertEqual(result, 28.4131, accuracy: accuracy)
    }
    
    func test_convertLargeImperialToSmallMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .pint, to: .millilitres)
        XCTAssertEqual(result, 568.261, accuracy: accuracy)
    }
    
    func test_convertSmallImperialToLargeMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .ounces, to: .litres)
        XCTAssertEqual(result, 0.0284131, accuracy: accuracy)
    }
    
    func test_convertLargeImperialToLargeMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .pint, to: .litres)
        XCTAssertEqual(result, 0.568261, accuracy: accuracy)
    }
    
    func test_convertSmallMetricToSmallImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .millilitres, to: .ounces)
        XCTAssertEqual(result, 0.0351951, accuracy: accuracy)
    }
    
    func test_convertSmallMetricToLargeImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .millilitres, to: .pint)
        XCTAssertEqual(result, 0.00175975, accuracy: accuracy)
    }
    
    func test_convertLargeMetricToSmallImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .litres, to: .ounces)
        XCTAssertEqual(result, 35.1951, accuracy: accuracy)
    }
    
    func test_convertLargeMetricToLargeImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .litres, to: .pint)
        XCTAssertEqual(result, 1.7597, accuracy: accuracy)
    }
    
    func test_convertSmallMetricToLargeMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .millilitres, to: .litres)
        XCTAssertEqual(result, 0.001, accuracy: accuracy)
    }
    
    func test_convertLargeMetricToSmallMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .litres, to: .millilitres)
        XCTAssertEqual(result, 1000, accuracy: accuracy)
    }
    
    func test_convert_500ml_to_oz() {
        let value = sut.convert(500, from: .millilitres, to: .ounces)
        XCTAssertEqual(value, 17.6, accuracy: accuracy)
    }
    
    func test_setAndGetUnitSystem() {
        userPreferenceService.stub.getKey_returnValue = UnitSystem.imperial
        let foundSystem: UnitSystem = sut.getUnitSystem()
        XCTAssertEqual(foundSystem, .imperial)
    }
    
    func test_setAndGetUnitSystem_failesSetting() {
        userPreferenceService.stub.setValueKey_returnValue = DummyError.setting
        sut.set(unitSystem: .imperial)
        let foundSystem: UnitSystem = sut.getUnitSystem()
        XCTAssertNotEqual(foundSystem, .imperial)
    }
}

extension UnitServiceTests {
    enum DummyError: Error {
        case setting
    }
}

//
//  UnitServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/08/2023.
//

import XCTest
import UnitServiceInterface
import UnitServiceMocks
@testable import UnitService

final class UnitServiceTests: XCTestCase {
    var sut: UnitServiceType!
    
    override func setUp() {
        self.sut = UnitService()
    }
    
    func test_convertSmallImperialToLargImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .ounces, to: .pint)
        XCTAssertEqual(result, 0.05, accuracy: 2)
    }
    
    func test_convertLargeImperialToSmallImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .pint, to: .ounces)
        XCTAssertEqual(result, 20, accuracy: 2)
    }
    
    func test_convertSmallImperialToSmallMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .ounces, to: .millilitres)
        XCTAssertEqual(result, 28.4131)
    }
    
    func test_convertLargeImperialToSmallMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .pint, to: .millilitres)
        XCTAssertEqual(result, 568.261)
    }
    
    func test_convertSmallImperialToLargeMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .ounces, to: .litres)
        XCTAssertEqual(result, 0.0284131)
    }
    
    func test_convertLargeImperialToLargeMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .pint, to: .litres)
        XCTAssertEqual(result, 0.568261)
    }
    
    func test_convertSmallMetricToSmallImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .millilitres, to: .ounces)
        XCTAssertEqual(result, 0.0351951, accuracy: 8)
    }
    
    func test_convertSmallMetricToLargeImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .millilitres, to: .pint)
        XCTAssertEqual(result, 0.00175975, accuracy: 8)
    }
    
    func test_convertLargeMetricToSmallImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .litres, to: .ounces)
        XCTAssertEqual(result, 35.1951, accuracy: 4)
    }
    
    func test_convertLargeMetricToLargeImperial() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .litres, to: .pint)
        XCTAssertEqual(result, 1.7597, accuracy: 4)
    }
    
    func test_convertSmallMetricToLargeMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .millilitres, to: .litres)
        XCTAssertEqual(result, 0.001)
    }
    
    func test_convertLargeMetricToSmallMetric() {
        let givenValue: Double = 1
        let result = sut.convert(givenValue, from: .litres, to: .millilitres)
        XCTAssertEqual(result, 1000)
    }
}

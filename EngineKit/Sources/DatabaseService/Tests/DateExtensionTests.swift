//
//  DateExtensionTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import XCTest
import Foundation
import TestHelper
@testable import DatabaseService

final class DateExtensionTests: XCTestCase {
    let referenceDate = XCTest.referenceDate
    
    func test_toDateString() {
        XCTAssertEqual(referenceDate.toDateString(), "01/07/2023")
    }
    
    func test_toDateString_invalidYear() {
        XCTAssertNotEqual(referenceDate.toDateString(), "01/07/23")
    }
    
    func test_toDateString_invalidShortMonth() {
        XCTAssertNotEqual(referenceDate.toDateString(), "01/Jul/2023")
    }
    
    func test_toDateString_invalidLongMonth() {
        XCTAssertNotEqual(referenceDate.toDateString(), "01/July/2023")
    }
    
    func test_toDateString_invalidDay() {
        XCTAssertNotEqual(referenceDate.toDateString(), "1/07/2023")
    }
    
    func test_toTimeString_success() {
        XCTAssertEqual(referenceDate.toTimeString(), "15:59:03")
    }
    
    func test_toTimeString_invalidSeconds() {
        XCTAssertNotEqual(referenceDate.toTimeString(), "15:59")
    }
    
    func test_toTimeString_invalidMinutes() {
        XCTAssertNotEqual(referenceDate.toTimeString(), "15::03")
    }
    
    func test_toTimeString_invalidHours() {
        XCTAssertNotEqual(referenceDate.toTimeString(), ":59:03")
    }
    
    func test_toTimeString_invalidSeperator() {
        XCTAssertNotEqual(referenceDate.toTimeString(), "15-59-03")
    }
}

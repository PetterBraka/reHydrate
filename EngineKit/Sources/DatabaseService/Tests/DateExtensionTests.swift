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
    
    func test_toString_success() {
        XCTAssertEqual(referenceDate.toString(), "01/07/2023")
    }
    
    func test_toString_invalidYear() {
        XCTAssertNotEqual(referenceDate.toString(), "01/07/23")
    }
    
    func test_toString_invalidShortMonth() {
        XCTAssertNotEqual(referenceDate.toString(), "01/Jul/2023")
    }
    
    func test_toString_invalidLongMonth() {
        XCTAssertNotEqual(referenceDate.toString(), "01/July/2023")
    }
    
    func test_toString_invalidDay() {
        XCTAssertNotEqual(referenceDate.toString(), "1/07/2023")
    }
}

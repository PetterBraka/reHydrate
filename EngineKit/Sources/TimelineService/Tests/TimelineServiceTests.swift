//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 12/08/2023.
//

import XCTest
import TestHelper
import DatabaseServiceInterface
import DatabaseServiceMocks
import TimelineServiceInterface
@testable import TimelineService

final class DayManagerTests: XCTestCase {
    typealias Engine = (
        HasConsumptionManagerService
    )
    
    var engine: Engine!
    var sut: TimelineServiceType!
    
    override func setUp() {
        self.sut = TimelineService(engine: engine)
    }
}

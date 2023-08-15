//
//  TimelineServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/08/2023.
//

import XCTest
import EngineMocks
import TestHelper
import DatabaseServiceInterface
import DatabaseServiceMocks
import TimelineServiceInterface
@testable import TimelineService

final class TimelineServiceTests: XCTestCase {
    typealias Engine = (
        HasConsumptionManagerService
    )
    
    var engine: Engine = EngineMocks()
    
    var stub: ConsumptionManagerStub!
    var sut: TimelineServiceType!
    
    override func setUp() {
        self.stub = ConsumptionManagerStub()
        self.engine.consumptionManager = stub
        self.sut = TimelineService(engine: engine)
    }
    
    func test_getTimelineForDate_success() async throws {
        let givenConsumption = [
            Consumption(id: "1", date: "01/02/2023", time: "01:20:22", consumed: 0.3),
            Consumption(id: "1", date: "01/02/2023", time: "02:00:01", consumed: 1),
            Consumption(id: "1", date: "01/02/2023", time: "02:05:44", consumed: 0.5)
        ]
        stub.fetchAllAtDate_returnValue = givenConsumption
        
        let timeline = await sut.getTimeline(for: XCTest.referenceDate)
        
        let expectedTimeline = givenConsumption.map { Timeline(time: $0.time, consumed: $0.consumed) }
        XCTAssertEqual(timeline, expectedTimeline)
    }
    
    func test_getTimelineForDate_failing() async throws {
        stub.fetchAllAtDate_returnError = DatabaseError.noElementFound
        
        let timeline = await sut.getTimeline(for: XCTest.referenceDate)
        
        XCTAssertEqual(timeline, [])
    }
    
    func test_getTimelineCollection_success() async throws {
        let givenConsumptionDay1 = [
            Consumption(id: "1", date: "01/02/2023", time: "01:20:22", consumed: 0.3),
            Consumption(id: "1", date: "01/02/2023", time: "02:00:01", consumed: 1),
            Consumption(id: "1", date: "01/02/2023", time: "02:05:44", consumed: 0.5)
        ]
        let givenConsumptionDay2 = [
            Consumption(id: "1", date: "02/02/2023", time: "08:32:01", consumed: 1),
            Consumption(id: "1", date: "02/02/2023", time: "05:05:44", consumed: 0.5)
        ]
        
        stub.fetchAll_returnValue = givenConsumptionDay1 + givenConsumptionDay2
        
        let timeline = await sut.getTimelineCollection()
        
        let expectedTimelineDay1 = givenConsumptionDay1.map { Timeline(time: $0.time, consumed: $0.consumed) }
        let expectedTimelineDay2 = givenConsumptionDay2.map { Timeline(time: $0.time, consumed: $0.consumed) }
        let expectedTimelineCollection = [
            TimelineCollection(dateString: givenConsumptionDay2[0].date,
                               timeline: expectedTimelineDay2),
            TimelineCollection(dateString: givenConsumptionDay1[0].date,
                               timeline: expectedTimelineDay1)
        ]
        XCTAssertEqual(timeline, expectedTimelineCollection)
    }
    
    func test_getTimelineCollection_failingOrder() async throws {
        let givenConsumptionDay1 = [
            Consumption(id: "1", date: "01/02/2023", time: "01:20:22", consumed: 0.3),
            Consumption(id: "1", date: "01/02/2023", time: "02:00:01", consumed: 1),
            Consumption(id: "1", date: "01/02/2023", time: "02:05:44", consumed: 0.5)
        ]
        let givenConsumptionDay2 = [
            Consumption(id: "1", date: "02/02/2023", time: "08:32:01", consumed: 1),
            Consumption(id: "1", date: "02/02/2023", time: "05:05:44", consumed: 0.5)
        ]
        
        stub.fetchAll_returnValue = givenConsumptionDay1 + givenConsumptionDay2
        
        let timeline = await sut.getTimelineCollection()
        
        let expectedTimelineDay1 = givenConsumptionDay1.map { Timeline(time: $0.time, consumed: $0.consumed) }
        let expectedTimelineDay2 = givenConsumptionDay2.map { Timeline(time: $0.time, consumed: $0.consumed) }
        let expectedTimelineCollection = [
            TimelineCollection(dateString: givenConsumptionDay1[0].date,
                               timeline: expectedTimelineDay1),
            TimelineCollection(dateString: givenConsumptionDay2[0].date,
                               timeline: expectedTimelineDay2)
        ]
        XCTAssertNotEqual(timeline, expectedTimelineCollection)
    }
    
    func test_getTimelineCollection_failing() async throws {
        stub.fetchAll_returnError = DatabaseError.noElementFound
        
        let timeline = await sut.getTimelineCollection()
        
        XCTAssertEqual(timeline, [])
    }
}

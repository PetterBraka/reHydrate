//
//  HealthKitPortTests.swift
//  reHydrateTests
//
//  Created by Petter vang Brakalsvålet on 17/03/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import XCTest
import HealthKit
import TestHelper
@testable import reHydrate

final class HealthKitPortTests: XCTestCase {
    var sut: HealthKitPort!
    
    override func setUp() async throws {
        await deleteAllData()
        sut = HealthKitPort()
        XCTAssertTrue(sut.isSupported)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_shouldRequestAccess_water() async {
        let shouldRequest = await sut.shouldRequestAccess(for: [.water(.litre)])
        XCTAssertFalse(shouldRequest)
    }
    
    func test_canWrite_water() {
        XCTAssertTrue(sut.canWrite(.water(.litre)))
    }
    
    func test_requestAuth() async throws {
        try await sut.requestAuth(toReadAndWrite: Set([.water(.litre)]))
    }
    
    func test_export() async throws {
        try await sut.export(
            quantity: .init(unit: .litre, value: 10),
            id: .dietaryWater,
            date: .init(year: 2018, month: 06, day: 10)
        )
    }
    
    func test_readSum() async throws {
        let sum = try await sut.readSum(
            .water(.litre),
            start: .init(year: 2018, month: 06, day: 10),
            end: .init(year: 2018, month: 06, day: 10, hours: 23),
            intervalComponents: .init(day: 1)
        )
        XCTAssertEqual(sum, 0)
    }
    
    func test_readSum_with1Item() async throws {
        try await sut.export(
            quantity: .init(unit: .litre, value: 2.1),
            id: .dietaryWater,
            date: .init(year: 2018, month: 06, day: 10)
        )
        let sum = try await sut.readSum(
            .water(.litre),
            start: .init(year: 2018, month: 06, day: 10),
            end: .init(year: 2018, month: 06, day: 10, hours: 23),
            intervalComponents: .init(day: 1)
        )
        XCTAssertEqual(sum, 2.1)
    }
    
    func test_readSum_with5Items() async throws {
        for _ in 1 ... 5 {
            try await sut.export(
                quantity: .init(unit: .litre, value: 1.1),
                id: .dietaryWater,
                date: .init(year: 2018, month: 06, day: 10)
            )
        }
        let sum = try await sut.readSum(
            .water(.litre),
            start: .init(year: 2018, month: 06, day: 10),
            end: .init(year: 2018, month: 06, day: 10, hours: 23),
            intervalComponents: .init(day: 1)
        )
        XCTAssertEqual(sum, 5.5)
    }
    
    func test_readSamples() async throws {
        let data = try await sut.readSamples(
            .water(.litre),
            start: .init(year: 2018, month: 06, day: 10),
            end: .init(year: 2018, month: 06, day: 10, hours: 23)
        )
        XCTAssertEqual(data, [])
    }
    
    func test_readSamples_with1Item() async throws {
        try await sut.export(
            quantity: .init(unit: .litre, value: 2.1),
            id: .dietaryWater,
            date: .init(year: 2018, month: 06, day: 10)
        )
        let data = try await sut.readSamples(
            .water(.litre),
            start: .init(year: 2018, month: 06, day: 10),
            end: .init(year: 2018, month: 06, day: 10, hours: 23)
        )
        XCTAssertEqual(data, [2.1])
    }
    
    func test_readSamples_with5Items() async throws {
        for _ in 1 ... 5 {
            try await sut.export(
                quantity: .init(unit: .litre, value: 1.1),
                id: .dietaryWater,
                date: .init(year: 2018, month: 06, day: 10)
            )
        }
        let data = try await sut.readSamples(
            .water(.litre),
            start: .init(year: 2018, month: 06, day: 10),
            end: .init(year: 2018, month: 06, day: 10, hours: 23)
        )
        XCTAssertEqual(data, [1.1, 1.1, 1.1, 1.1, 1.1])
    }
}

private extension HealthKitPortTests {
    func deleteAllData() async {
        let store = HKHealthStore()
        _ = try? await store.deleteObjects(
            of: HKQuantityType(.dietaryWater),
            predicate: HKQuery.predicateForSamples(withStart: .distantPast,
                                                   end: .distantFuture)
        )
    }
}

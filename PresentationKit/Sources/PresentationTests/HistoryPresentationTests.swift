//
//  HistoryPresentationTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/02/2024.
//

import XCTest
import TestHelper
import EngineMocks
import DayServiceInterface
import DayServiceMocks
import DateServiceMocks
import UnitService
import UnitServiceInterface
import UnitServiceMocks
import UserPreferenceServiceMocks
@testable import PresentationKit

final class HistoryPresentationTests: XCTestCase {
    private typealias Sut = Screen.History.Presenter
    
    private var engine: EngineMocks!
    private var router: RouterSpy!
    
    private var sut: Sut!
    
    private var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    private var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    private var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    private var unitService: (realObject: UnitServiceType, spy: UnitServiceTypeSpying)!
    
    override func setUp() async throws {
        router = RouterSpy()
        engine = EngineMocks()
        dayService = engine.makeDayService()
        dateService = engine.makeDateService()
        userPreferenceService = engine.makeUserPreferenceService()
        unitService = engine.makeUnitService(UnitService(engine: engine))
        
        dateService.stub.now_returnValue = .init(year: 2024, month: 2, day: 15)
        dateService.stub.getDateValueComponentDate_returnValue = .init(year: 2024 - 5, month: 2, day: 15)
        dateService.stub.getDateValueComponentDate_returnValue = .init(year: 2024, month: 2, day: 15 - 6)
        
        sut = Sut(engine: engine, router: router)
    }
    
    override func tearDown() {
        router = nil
        engine = nil
        dayService = nil
        dateService = nil
        userPreferenceService = nil
    }
    
    // MARK: - init
    func test_init() {
        dateService.stub.now_returnValue = .init(year: 2024, month: 2, day: 15)
        dateService.stub.getDateValueComponentDate_returnValue = .init(year: 2024 - 5, month: 2, day: 15)
        dateService.stub.getDateValueComponentDate_returnValue = .init(year: 2024, month: 2, day: 15 - 6)
        
        sut = Sut(engine: engine, router: router)
        
        assertViewModel(sut.viewModel, .init(
            isLoading: false,
            details: .init(averageConsumed: "", averageGoal: "", totalConsumed: "", totalGoal: ""),
            chart: .init(title: "", points: [], selectedOption: .line),
            calendar: .init(
                highlightedMonth: .init(year: 2024, month: 2, day: 15),
                weekdayStart: .monday,
                range: .init(year: 2024 - 5, month: 2, day: 15) ... .init(year: 2024, month: 2, day: 15),
                days: []),
            selectedRange: nil,
            selectedDays: 0,
            error: nil
        ))
    }
    
    func test_init_backgroundJob() async throws {
        dateService.stub.now_returnValue = Date(year: 2024, month: 2, day: 15)
        
        dateService.stub.getDateValueComponentDate_returnValue = .init(year: 2024 - 5, month: 2, day: 15)
        dateService.stub.getDateValueComponentDate_returnValue = .init(year: 2024, month: 2, day: 15 - 6)
        dateService.stub.daysBetweenStartEnd_returnValue = 6
        
        dayService.stub.getToday_returnValue = .init(date: Date(year: 2024, month: 2, day: 15),
                                                     consumed: 0,
                                                     goal: 2.5)
        dayService.stub.getDaysDates_returnValue = .success([
            Day(date: .init(year: 2024, month: 2, day: 14), consumed: 1, goal: 2.5),
            Day(date: Date(year: 2024, month: 2, day: 15), consumed: 0, goal: 2.5)
        ])
        
        sut = Sut(engine: engine, router: router)
        
        try await Task.sleep(nanoseconds: 250_000_000)
        
        assertViewModel(sut.viewModel, .init(
            isLoading: false,
            details: .init(
                averageConsumed: "0.17 L",
                averageGoal: "0.83 L",
                totalConsumed: "1 L",
                totalGoal: "5 L"
            ),
            chart: .init(
                title: "09/02/2024 - 15/02/2024",
                points: [
                    .init(
                        date: Date(year: 2024, month: 2, day: 14),
                        dateString: "14/02/2024",
                        consumed: 1,
                        goal: 2.5
                    ),
                    .init(
                        date: Date(year: 2024, month: 2, day: 15),
                        dateString: "15/02/2024",
                        consumed: 0,
                        goal: 2.5
                    )
                ],
                selectedOption: .line
            ),
            calendar: .init(
                highlightedMonth: Date(year: 2024, month: 2, day: 15),
                weekdayStart: .monday,
                range: Date(year: 2024 - 5, month: 2, day: 15) ... Date(year: 2024, month: 2, day: 15),
                days: [
                    .init(date: Date(year: 2024, month: 2, day: 14), consumed: 1, goal: 2.5),
                    .init(date: Date(year: 2024, month: 2, day: 15), consumed: 0, goal: 2.5)
                ]),
            selectedRange: Date(year: 2024, month: 2, day: 15 - 6) ... Date(year: 2024, month: 2, day: 15),
            selectedDays: 6,
            error: nil
        ))
    }
    
    // MARK: - perform Action
    func test_didAppear() async throws {
        dateService.stub.daysBetweenStartEnd_returnValue = 6
        dateService.stub.daysBetweenStartEnd_returnValue = 6
        dateService.stub.getDateValueComponentDate_returnValue = .init(year: 2024, month: 2, day: 15 - 6)
        
        dayService.stub.getDaysDates_returnValue = .success([
            Day(date: Date(year: 2024, month: 2, day: 12), consumed: 2, goal: 2.5),
            Day(date: Date(year: 2024, month: 2, day: 13), consumed: 1, goal: 2.5),
            Day(date: Date(year: 2024, month: 2, day: 15), consumed: 0, goal: 2.5)
        ])
        
        await sut.perform(action: .didAppear)
        
        assertViewModel(sut.viewModel, .init(
            isLoading: false,
            details: .init(
                averageConsumed: "0.5 L",
                averageGoal: "1.25 L",
                totalConsumed: "3 L",
                totalGoal: "7.5 L"
            ),
            chart: .init(
                title: "09/02/2024 - 15/02/2024",
                points: [
                    .init(
                        date: .init(year: 2024, month: 2, day: 12),
                        dateString: "12/02/2024",
                        consumed: 2,
                        goal: 2.5
                    ),
                    .init(
                        date: .init(year: 2024, month: 2, day: 13),
                        dateString: "13/02/2024",
                        consumed: 1,
                        goal: 2.5
                    ),
                    .init(
                        date: Date(year: 2024, month: 2, day: 15),
                        dateString: "15/02/2024",
                        consumed: 0,
                        goal: 2.5
                    )
                ],
                selectedOption: .line
            ),
            calendar: .init(
                highlightedMonth: Date(year: 2024, month: 2, day: 15),
                weekdayStart: .monday,
                range: Date(year: 2024 - 5, month: 2, day: 15) ... Date(year: 2024, month: 2, day: 15),
                days: [
                    .init(date: Date(year: 2024, month: 2, day: 12), consumed: 2, goal: 2.5),
                    .init(date: Date(year: 2024, month: 2, day: 13), consumed: 1, goal: 2.5),
                    .init(date: Date(year: 2024, month: 2, day: 15), consumed: 0, goal: 2.5)
                ]),
            selectedRange: Date(year: 2024, month: 2, day: 15 - 6) ... Date(year: 2024, month: 2, day: 15),
            selectedDays: 6,
            error: nil
        ))
    }
}

extension HistoryPresentationTests {
    private func assertViewModel(_ givenViewModel: Sut.ViewModel, _ expectedViewModel: Sut.ViewModel,
                                 file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(givenViewModel.isLoading, expectedViewModel.isLoading, "isLoading", file: file, line: line)
        XCTAssertEqual(givenViewModel.details, expectedViewModel.details, "details", file: file, line: line)
        XCTAssertEqual(givenViewModel.chart, expectedViewModel.chart, "chart", file: file, line: line)
        XCTAssertEqual(givenViewModel.calendar, expectedViewModel.calendar, "calendar", file: file, line: line)
        XCTAssertEqual(givenViewModel.selectedRange, expectedViewModel.selectedRange, "selectedRange", file: file, line: line)
        XCTAssertEqual(givenViewModel.selectedDays, expectedViewModel.selectedDays, "selectedDays", file: file, line: line)
        
        XCTAssertEqual(givenViewModel.error, expectedViewModel.error, "error", file: file, line: line)
    }
}

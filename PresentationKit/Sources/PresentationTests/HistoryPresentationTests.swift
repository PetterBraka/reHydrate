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
import PresentationInterface
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
        dateService.stub.getDateValueComponentDate_returnValue = .init(year: 2024, month: 2, day: 9)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = .init(identifier: "en_GB")
        
        sut = Sut(engine: engine, router: router, formatter: formatter)
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
        XCTAssertEqual(router.log, [])
        assertViewModel(sut.viewModel, .init(
            isLoading: false,
            details: .init(averageConsumed: "", averageGoal: "", totalConsumed: "", totalGoal: ""),
            chart: .init(title: "", points: [], selectedOption: .line),
            calendar: .init(
                highlightedMonth: .init(year: 2024, month: 2, day: 15),
                weekdayStart: .monday,
                range: Date(year: 2024 - 5, month: 2, day: 15) ... Date(year: 2024, month: 2, day: 15),
                days: []),
            selectedRange: Date(year: 2024, month: 2, day: 9) ... Date(year: 2024, month: 2, day: 15),
            selectedDays: 0,
            error: nil
        ))
    }
    
    // MARK: - perform Action
    // MARK: didAppear
    func test_didAppear() async {
        dateService.stub.daysBetweenStartEnd_returnValue = 6
        dayService.stub.getDaysDates_returnValue = .success([
            Day(date: Date(year: 2024, month: 2, day: 12), consumed: 2, goal: 2.5),
            Day(date: Date(year: 2024, month: 2, day: 13), consumed: 1, goal: 2.5),
            Day(date: Date(year: 2024, month: 2, day: 15), consumed: 0, goal: 2.5)
        ])
        
        await sut.perform(action: .didAppear)
        
        XCTAssertEqual(router.log, [])
        assertViewModel(.init(
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
    
    // MARK: didTapBack
    func test_didTapBack() async {
        await sut.perform(action: .didTapBack)
        XCTAssertEqual(router.log, [.showHome])
    }
    
    // MARK: didSelectChartOption
    func test_didSelectChartOption_bar() async {
        await sut.perform(action: .didSelectChart(.bar))
        XCTAssertEqual(router.log, [])
        assertChart(.init(
            title: "09/02/2024 - 15/02/2024",
            points: [],
            selectedOption: .bar
        ))
    }
    
    func test_didSelectChartOption_line() async {
        await sut.perform(action: .didSelectChart(.line))
        XCTAssertEqual(router.log, [])
        assertChart(.init(
            title: "09/02/2024 - 15/02/2024",
            points: [],
            selectedOption: .line
        ))
    }
    
    func test_didSelectChartOption_plot() async {
        await sut.perform(action: .didSelectChart(.plot))
        XCTAssertEqual(router.log, [])
        assertChart(.init(
            title: "09/02/2024 - 15/02/2024",
            points: [],
            selectedOption: .plot
        ))
    }
    
    // MARK: didTapClear
    func test_didTapClear() async {
        assertViewModel(.init(
            isLoading: false,
            details: .init(
                averageConsumed: "",
                averageGoal: "",
                totalConsumed: "",
                totalGoal: ""
            ),
            chart: .init(
                title: "",
                points: [],
                selectedOption: .line
            ),
            calendar: .init(
                highlightedMonth: Date(year: 2024, month: 2, day: 15),
                weekdayStart: .monday,
                range: Date(year: 2024 - 5, month: 2, day: 15) ... Date(year: 2024, month: 2, day: 15),
                days: []
            ),
            selectedRange: Date(year: 2024, month: 2, day: 9) ... Date(year: 2024, month: 2, day: 15),
            selectedDays: 0,
            error: nil
        ))
        
        await sut.perform(action: .didTapClear)
        assertViewModel(.init(
            isLoading: false,
            details: .init(
                averageConsumed: "",
                averageGoal: "",
                totalConsumed: "",
                totalGoal: ""
            ),
            chart: .init(
                title: "09/02/2024 - 15/02/2024",
                points: [],
                selectedOption: .line
            ),
            calendar: .init(
                highlightedMonth: Date(year: 2024, month: 2, day: 15),
                weekdayStart: .monday,
                range: Date(year: 2024 - 5, month: 2, day: 15) ... Date(year: 2024, month: 2, day: 15),
                days: []
            ),
            selectedRange: nil,
            selectedDays: 0,
            error: nil
        ))
    }
    
    func test_didTapClear_afterDidAppear() async {
        dayService.stub.getDaysDates_returnValue = .success([
            .init(date: Date(year: 2024, month: 2, day: 14), consumed: 0, goal: 2),
            .init(date: Date(year: 2024, month: 2, day: 15), consumed: 0, goal: 2)
        ])
        await sut.perform(action: .didAppear)
        
        await sut.perform(action: .didTapClear)
        assertViewModel(.init(
            isLoading: false,
            details: .init(
                averageConsumed: "0 L",
                averageGoal: "4 L",
                totalConsumed: "0 L",
                totalGoal: "4 L"
            ),
            chart: .init(
                title: "09/02/2024 - 15/02/2024",
                points: [
                    .init(date: Date(year: 2024, month: 2, day: 14), dateString: "14/02/2024", consumed: 0, goal: 2),
                    .init(date: Date(year: 2024, month: 2, day: 15), dateString: "15/02/2024", consumed: 0, goal: 2)
                ],
                selectedOption: .line
            ),
            calendar: .init(
                highlightedMonth: Date(year: 2024, month: 02, day: 15),
                weekdayStart: .monday,
                range: Date(year: 2024 - 5, month: 2, day: 15) ... Date(year: 2024, month: 2, day: 15),
                days: [
                    .init(date: Date(year: 2024, month: 2, day: 14), consumed: 0, goal: 2),
                    .init(date: Date(year: 2024, month: 2, day: 15), consumed: 0, goal: 2)
                ]
            ),
            selectedRange: nil,
            selectedDays: 1,
            error: nil
        ))
    }
    
    // MARK: didTapDate
    func test_didTapDate_oneDayBefore() async {
        dateService.stub.daysBetweenStartEnd_returnValue = 2
        dateService.stub.daysBetweenStartEnd_returnValue = 4
        dateService.stub.daysBetweenStartEnd_returnValue = 4
        dayService.stub.getDaysDates_returnValue = .success([
            .init(date: Date(year: 2024, month: 2, day: 13), consumed: 2, goal: 2),
            .init(date: Date(year: 2024, month: 2, day: 14), consumed: 0, goal: 2),
            .init(date: Date(year: 2024, month: 2, day: 15), consumed: 0, goal: 2)
        ])
        
        await sut.perform(action: .didTap(Date(year: 2024, month: 2, day: 13)))
        assertViewModel(.init(
            isLoading: false,
            details: .init(
                averageConsumed: "0.5 L",
                averageGoal: "1.5 L",
                totalConsumed: "2 L",
                totalGoal: "6 L"
            ),
            chart: .init(
                title: "13/02/2024 - 15/02/2024",
                points: [
                    .init(date: Date(year: 2024, month: 2, day: 13), dateString: "13/02/2024", consumed: 2, goal: 2),
                    .init(date: Date(year: 2024, month: 2, day: 14), dateString: "14/02/2024", consumed: 0, goal: 2),
                    .init(date: Date(year: 2024, month: 2, day: 15), dateString: "15/02/2024", consumed: 0, goal: 2)
                ],
                selectedOption: .line
            ),
            calendar: .init(
                highlightedMonth: Date(year: 2024, month: 02, day: 13),
                weekdayStart: .monday,
                range: Date(year: 2024 - 5, month: 2, day: 15) ... Date(year: 2024, month: 2, day: 15),
                days: [
                    .init(date: Date(year: 2024, month: 2, day: 13), consumed: 2, goal: 2),
                    .init(date: Date(year: 2024, month: 2, day: 14), consumed: 0, goal: 2),
                    .init(date: Date(year: 2024, month: 2, day: 15), consumed: 0, goal: 2)
                ]
            ),
            selectedRange: Date(year: 2024, month: 2, day: 13) ... Date(year: 2024, month: 2, day: 15),
            selectedDays: 4,
            error: nil
        ))
    }
}

extension HistoryPresentationTests {
    private func assertViewModel(_ expectedViewModel: Sut.ViewModel,
                                 file: StaticString = #file, line: UInt = #line) {
        assertViewModel(sut.viewModel, expectedViewModel, file: file, line: line)
    }
    
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
    
    private func assertDetails(_ expectedDetails: Sut.ViewModel.Details,
                               file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.viewModel.details, expectedDetails, "details", file: file, line: line)
    }
    
    private func assertChart(_ expectedChart: Sut.ViewModel.ChartData,
                             file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.viewModel.chart, expectedChart, "chart", file: file, line: line)
    }
    
    private func assertCalendar(_ expectedCalendar: Sut.ViewModel.CalendarData,
                                file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.viewModel.calendar, expectedCalendar, "calendar", file: file, line: line)
    }
}

extension Screen.History.Presenter.ViewModel.ChartData: CustomStringConvertible {
    public var description: String {
        """
title: \(title)
points: \(points.description)
selectedOption: \(selectedOption.rawValue)
options: \(options.map { $0.rawValue })
"""
    }
}

extension Screen.History.Presenter.ViewModel.ChartData.Point: CustomStringConvertible {
    public var description: String {
        """

    date: \(date)
    dateString: \(dateString)
    consumed: \(consumed ?? 999)
    goal: \(goal ?? 999)
"""
    }
}

extension Screen.History.Presenter.ViewModel.CalendarData: CustomStringConvertible {
    public var description: String {
        """

highlightedMonth: \(highlightedMonth)
weekdayStart: \(weekdayStart)
range: \(range)
days: \(days.description)
"""
    }
}

extension Screen.History.Presenter.ViewModel.CalendarData.Day: CustomStringConvertible {
    public var description: String {
        """

    date: \(date)
    consumed: \(consumed)
    goal: \(goal)

"""
    }
}

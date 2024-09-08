import XCTest
import TestHelper
import UnitService
import EngineMocks
import DayServiceMocks
import WatchCommsMocks
import DateServiceMocks
import DrinkServiceMocks
import WatchCommsInterface
import DayServiceInterface
import UnitServiceInterface
import DrinkServiceInterface
import UserPreferenceServiceMocks
import PresentationWatchInterface
@testable import PresentationWatchKit

final class PresentationWatchKitTests: XCTestCase {
    var notificationCenter: NotificationCenter!
    var sut: HomePresenterType!
    
    var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    var drinkService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    var watchComms: (stub: WatchCommsTypeStubbing, spy: WatchCommsTypeSpying)!
    var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    
    override func setUp() {
        notificationCenter = NotificationCenter.default
        let engine = EngineMocks()
        engine.unitService = UnitService(engine: engine)
        dayService = engine.makeDayService()
        dateService = engine.makeDateService()
        drinkService = engine.makeDrinksService()
        userPreferenceService = engine.makeUserPreferenceService()
        watchComms = engine.makeWatchComms()
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE - dd MMM", options: 0, locale: .init(identifier: "en_gb"))
        
        engine.unitService.set(unitSystem: .metric)
        sut = Screen.Home.Presenter(
            engine: engine,
            formatter: formatter,
            notificationCenter: notificationCenter
        )
    }
    
    override func tearDown() {
        notificationCenter = nil
        sut = nil
        dayService = nil
        dateService = nil
        drinkService = nil
        watchComms = nil
        userPreferenceService = nil
    }
    
    // MARK: init
    func test_init() {
        assert(viewModel: .init(consumption: 0, goal: 0, unit: .liters, drinks: []))
    }
    
    // MARK: didAppear
    func test_didAppear() async {
        dayService.stub.getToday_returnValue = .init(date: Date(year: 2024, month: 2, day: 6), consumed: 1, goal: 2)
        drinkService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        await sut.perform(action: .didAppear)
        assert(viewModel: .init(
            consumption: 1,
            goal: 2,
            unit: .liters,
            drinks: [
                .init(size: 100, container: .small),
                .init(size: 200, container: .medium),
                .init(size: 300, container: .large)
            ]
        ))
        XCTAssertEqual(watchComms.spy.methodLog, [.addObserver(updateBlock: {})])
    }
    
    // MARK: didTapAddDrink
    func test_didTapAddDrink_missingDrink() async {
        await sut.perform(action: .didTapAddDrink(.small))
        assert(viewModel: .init(
            consumption: 0,
            goal: 0,
            unit: .liters,
            drinks: []
        ))
    }
    
    func test_didTapAddDrink_small() async {
        dayService.stub.getToday_returnValue = .init(date: Date(year: 2024, month: 2, day: 6), consumed: 1, goal: 2)
        drinkService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        dayService.stub.addDrink_returnValue = .success(1.1)
        await sut.perform(action: .didAppear)
        await sut.perform(action: .didTapAddDrink(.small))
        assert(viewModel: .init(
            consumption: 1.1,
            goal: 2,
            unit: .liters,
            drinks: [
                .init(size: 100, container: .small),
                .init(size: 200, container: .medium),
                .init(size: 300, container: .large)
            ]
        ))
    }
    
    func test_didTapAddDrink_medium() async {
        dayService.stub.getToday_returnValue = .init(date: Date(year: 2024, month: 2, day: 6), consumed: 1, goal: 2)
        drinkService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        dayService.stub.addDrink_returnValue = .success(1.2)
        await sut.perform(action: .didAppear)
        await sut.perform(action: .didTapAddDrink(.medium))
        assert(viewModel: .init(
            consumption: 1.2,
            goal: 2,
            unit: .liters,
            drinks: [
                .init(size: 100, container: .small),
                .init(size: 200, container: .medium),
                .init(size: 300, container: .large)
            ]
        ))
    }
    
    func test_didTapAddDrink_large() async {
        dayService.stub.getToday_returnValue = .init(date: Date(year: 2024, month: 2, day: 6), consumed: 1, goal: 2)
        drinkService.stub.getSaved_returnValue = .success([
            .init(id: "1", size: 100, container: .small),
            .init(id: "2", size: 200, container: .medium),
            .init(id: "3", size: 300, container: .large)
        ])
        dayService.stub.addDrink_returnValue = .success(1.3)
        await sut.perform(action: .didAppear)
        await sut.perform(action: .didTapAddDrink(.large))
        assert(viewModel: .init(
            consumption: 1.3,
            goal: 2,
            unit: .liters,
            drinks: [
                .init(size: 100, container: .small),
                .init(size: 200, container: .medium),
                .init(size: 300, container: .large)
            ]
        ))
    }
}

private extension PresentationWatchKitTests {
    func assert(viewModel: Screen.Home.Presenter.ViewModel, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.viewModel.consumption, viewModel.consumption, accuracy: 0.1, "consumption", file: file, line: line)
        XCTAssertEqual(sut.viewModel.goal, viewModel.goal, accuracy: 0.1, "goal", file: file, line: line)
        XCTAssertEqual(sut.viewModel.unit.symbol, viewModel.unit.symbol, "unit", file: file, line: line)
        XCTAssertEqual(sut.viewModel.drinks.count, viewModel.drinks.count, "drinks count", file: file, line: line)
        for drink in zip(sut.viewModel.drinks, viewModel.drinks) {
            XCTAssertEqual(drink.0.size, drink.1.size, accuracy: 0.1, "\(drink.0.container.rawValue) drink", file: file, line: line)
            XCTAssertEqual(drink.0.container, drink.1.container, "\(drink.0.container.rawValue) drink", file: file, line: line)
        }
    }
}

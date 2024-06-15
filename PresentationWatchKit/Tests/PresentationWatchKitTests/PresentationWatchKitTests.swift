import XCTest
import TestHelper
import UnitService
import EngineMocks
import DayServiceMocks
import DateServiceMocks
import UnitServiceMocks
import DrinkServiceMocks
import CommunicationKitMock
import PresentationWatchInterface
@testable import PresentationWatchKit

final class PresentationWatchKitTests: XCTestCase {
    var sut: HomePresenterType!
    
    var dayService: (stub: DayServiceTypeStubbing, spy: DayServiceTypeSpying)!
    var dateService: (stub: DateServiceTypeStubbing, spy: DateServiceTypeSpying)!
    var drinkService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    
    var watchService: (stub: WatchServiceTypeStub, spy: WatchServiceTypeSpying)!
    
    override func setUp() {
        let engine = EngineMocks()
        dayService = engine.makeDayService()
        engine.unitService = UnitService(engine: engine)
        dateService = engine.makeDateService()
        drinkService = engine.makeDrinksService()
        
        let watchServiceStub = WatchServiceTypeStub()
        let watchServiceSpy = WatchServiceTypeSpy(realObject: watchServiceStub)
        watchService = (watchServiceStub, watchServiceSpy)
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE - dd MMM", options: 0, locale: .init(identifier: "en_gb"))
        
        sut = Screen.Home.Presenter(
            engine: engine,
            watchService: watchService.stub,
            formatter: formatter,
            notificationCenter: .default
        )
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
            )
        )
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
        XCTAssertEqual(sut.viewModel.unit, viewModel.unit, "unit", file: file, line: line)
        XCTAssertEqual(sut.viewModel.drinks.count, viewModel.drinks.count, "drinks", file: file, line: line)
        for drink in zip(sut.viewModel.drinks, viewModel.drinks) {
            XCTAssertEqual(drink.0.size, drink.1.size, accuracy: 0.1, "\(drink.0.container.rawValue) drink", file: file, line: line)
            XCTAssertEqual(drink.0.container, drink.1.container, "\(drink.0.container.rawValue) drink", file: file, line: line)
        }
    }
}

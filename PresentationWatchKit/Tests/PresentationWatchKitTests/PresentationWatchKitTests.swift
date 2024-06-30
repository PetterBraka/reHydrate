import XCTest
import TestHelper
import UnitService
import EngineMocks
import DayServiceMocks
import DateServiceMocks
import DrinkServiceMocks
import CommunicationKitMock
import CommunicationKitInterface
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
    var watchService: (stub: WatchServiceTypeStub, spy: WatchServiceTypeSpying)!
    var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    
    override func setUp() {
        notificationCenter = NotificationCenter.default
        let engine = EngineMocks()
        engine.unitService = UnitService(engine: engine)
        dayService = engine.makeDayService()
        dateService = engine.makeDateService()
        drinkService = engine.makeDrinksService()
        userPreferenceService = engine.makeUserPreferenceService()
        
        let watchServiceStub = WatchServiceTypeStub()
        let watchServiceSpy = WatchServiceTypeSpy(realObject: watchServiceStub)
        watchService = (watchServiceStub, watchServiceSpy)
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE - dd MMM", options: 0, locale: .init(identifier: "en_gb"))
        
        engine.unitService.set(unitSystem: .metric)
        sut = Screen.Home.Presenter(
            engine: engine,
            watchService: watchService.stub,
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
        watchService = nil
        userPreferenceService = nil
    }
}

// MARK: init
extension PresentationWatchKitTests {
    func test_init() {
        assert(viewModel: .init(consumption: 0, goal: 0, unit: .liters, drinks: []))
    }
}

// MARK: didAppear
extension PresentationWatchKitTests {
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
}

// MARK: didTapAddDrink
extension PresentationWatchKitTests {
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

// MARK: Notification
extension PresentationWatchKitTests {
    func test_didReceiveApplicationContext_isReceived() async {
        let processedNotification = XCTNSNotificationExpectation(name: .init("NotificationProcessed"))
        notificationCenter.post(name: .Watch.didReceiveApplicationContext, object: self, userInfo: [:])
        await fulfillment(of: [processedNotification], timeout: 2)
    }
    
    func test_didReceiveMessage_isReceived() async {
        let processedNotification = XCTNSNotificationExpectation(name: .init("NotificationProcessed"))
        NotificationCenter.default.post(name: .Watch.didReceiveMessage, object: nil, userInfo: [:])
        await fulfillment(of: [processedNotification], timeout: 2)
    }
    
    func test_didReceiveUserInfo_isReceived() async {
        let processedNotification = XCTNSNotificationExpectation(name: .init("NotificationProcessed"))
        NotificationCenter.default.post(name: .Watch.didReceiveUserInfo, object: nil, userInfo: [:])
        await fulfillment(of: [processedNotification], timeout: 2)
    }
    
    func test_didReceiveNotification() async {
        dateService.stub.isDateDateInSameDayAs_returnValue = true
        drinkService.stub.getSaved_returnValue = .success([
            Drink(id: "1", size: 100, container: .small),
            Drink(id: "2", size: 200, container: .medium),
            Drink(id: "3", size: 300, container: .large)
        ])
        let processedNotification = XCTNSNotificationExpectation(name: .init("NotificationProcessed"))
        let userInfo: [CommunicationUserInfo: Any] = [
            .day: Day(id: "test", date: Date(year: 2021, month: 12, day: 10), consumed: 1, goal: 2),
            .drinks: [
                Drink(id: "1", size: 100, container: .small),
                Drink(id: "2", size: 200, container: .medium),
                Drink(id: "3", size: 300, container: .large)
            ],
            .unitSystem: UnitSystem.metric
        ]
        notificationCenter.post(name: .Watch.didReceiveApplicationContext, object: self, userInfo: userInfo)
        await fulfillment(of: [processedNotification], timeout: 2)
        assert(viewModel: .init(consumption: 1, goal: 2, unit: .liters, drinks: [
            .init(size: 100, container: .small),
            .init(size: 200, container: .medium),
            .init(size: 300, container: .large)
        ]))
    }
    
    func test_didReceiveNotification_onlyDay() async {
        drinkService.stub.getSaved_returnValue = .success([])
        drinkService.stub.resetToDefault_returnValue = []
        dateService.stub.isDateDateInSameDayAs_returnValue = true
        let processedNotification = XCTNSNotificationExpectation(name: .init("NotificationProcessed"))
        let userInfo: [CommunicationUserInfo: Any] = [
            .day: Day(id: "test", date: Date(year: 2021, month: 12, day: 8), consumed: 1, goal: 2)
        ]
        notificationCenter.post(name: .Watch.didReceiveApplicationContext, object: self, userInfo: userInfo)
        await fulfillment(of: [processedNotification], timeout: 2)
        assert(viewModel: .init(consumption: 1, goal: 2, unit: .liters, drinks: []))
    }
    
    func test_didReceiveNotification_onlyDrinks() async {
        dayService.stub.getToday_returnValue = .init(date: Date(year: 2018, month: 6, day: 10), consumed: 0, goal: 2)
        drinkService.stub.getSaved_returnValue = .success([
            Drink(id: "1", size: 100, container: .small),
            Drink(id: "2", size: 200, container: .medium),
            Drink(id: "3", size: 300, container: .large),
        ])
        let processedNotification = XCTNSNotificationExpectation(name: .init("NotificationProcessed"))
        let userInfo: [CommunicationUserInfo: Any] = [
            .drinks: [
                Drink(id: "1", size: 100, container: .small),
                Drink(id: "2", size: 200, container: .medium),
                Drink(id: "3", size: 300, container: .large),
            ]
        ]
        notificationCenter.post(name: .Watch.didReceiveApplicationContext, object: self, userInfo: userInfo)
        await fulfillment(of: [processedNotification], timeout: 2)
        assert(viewModel: .init(consumption: 0, goal: 2, unit: .liters, drinks: [
            .init(size: 100, container: .small),
            .init(size: 200, container: .medium),
            .init(size: 300, container: .large),
        ]))
    }
    
    func test_didReceiveNotification_onlyDrinks_editWhenDifferent() async {
        dayService.stub.getToday_returnValue = .init(date: Date(year: 2018, month: 6, day: 10), consumed: 0, goal: 2)
        drinkService.stub.addSizeContainer_returnValue = .success(.init(id: "2", size: 200, container: .medium))
        drinkService.stub.getSaved_returnValue = .success([
            Drink(id: "1", size: 100, container: .small),
            Drink(id: "3", size: 300, container: .large),
        ])
        let processedNotification = XCTNSNotificationExpectation(name: .init("NotificationProcessed"))
        let userInfo: [CommunicationUserInfo: Any] = [
            .drinks: [
                Drink(id: "1", size: 100, container: .small),
                Drink(id: "2", size: 200, container: .medium),
                Drink(id: "3", size: 300, container: .large),
            ]
        ]
        notificationCenter.post(name: .Watch.didReceiveApplicationContext, object: self, userInfo: userInfo)
        await fulfillment(of: [processedNotification], timeout: 2)
        assert(viewModel: .init(consumption: 0, goal: 2, unit: .liters, drinks: [
            .init(size: 100, container: .small),
            .init(size: 200, container: .medium),
            .init(size: 300, container: .large),
        ]))
    }
    
    func test_didReceiveNotification_onlyUnit_metric() async {
        dayService.stub.getToday_returnValue = .init(date: Date(year: 2018, month: 6, day: 10), consumed: 0, goal: 2)
        drinkService.stub.getSaved_returnValue = .success([.init(id: "1", size: 200, container: .medium)])
        let processedNotification = XCTNSNotificationExpectation(name: .init("NotificationProcessed"))
        let userInfo: [CommunicationUserInfo: Any] = [
            .unitSystem: UnitSystem.metric
        ]
        notificationCenter.post(name: .Watch.didReceiveApplicationContext, object: self, userInfo: userInfo)
        await fulfillment(of: [processedNotification], timeout: 2)
        assert(viewModel: .init(consumption: 0, goal: 2, unit: .liters, drinks: [.init(size: 200, container: .medium)]))
    }
    
    func test_didReceiveNotification_onlyUnit_imperial() async {
        dayService.stub.getToday_returnValue = .init(date: Date(year: 2018, month: 6, day: 10), consumed: 0, goal: 2)
        drinkService.stub.getSaved_returnValue = .success([.init(id: "1", size: 200, container: .medium)])
        userPreferenceService.stub.getKey_returnValue = UnitSystem.imperial
        let processedNotification = XCTNSNotificationExpectation(name: .init("NotificationProcessed"))
        let userInfo: [CommunicationUserInfo: Any] = [
            .unitSystem: UnitSystem.imperial
        ]
        notificationCenter.post(name: .Watch.didReceiveApplicationContext, object: self, userInfo: userInfo)
        await fulfillment(of: [processedNotification], timeout: 2)
        assert(viewModel: .init(consumption: 0, goal: 3.52, unit: .pints, drinks: [.init(size: 7, container: .medium)]))
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

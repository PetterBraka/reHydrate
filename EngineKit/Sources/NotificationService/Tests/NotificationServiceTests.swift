//
//  NotificationServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/09/2023.
//

import XCTest
import TestHelper
import EngineMocks
import LoggingService
import UserPreferenceServiceMocks
import UserPreferenceServiceInterface
import DrinkServiceInterface
import NotificationServiceMocks
import NotificationServiceInterface
import DateServiceInterface
import DateServiceMocks
@testable import NotificationService

final class NotificationServiceTests: XCTestCase {
    typealias Engine = (
        HasLoggingService &
        HasUserPreferenceService &
        HasDrinksService &
        HasDateService
    )
    
    var engine: EngineMocks!
    
    var userNotificationCenter: (stub: UserNotificationCenterTypeStub, spy: UserNotificationCenterTypeSpy)!
    var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    
    var sut: NotificationServiceType!
    
    let dummyNotificationRequest = NotificationRequest(
        identifier: "dumy",
        content: .init(title: "dumy", subtitle: "dumy", body: "dumy", 
                       categoryIdentifier: "dumy", userInfo: [:]),
        trigger: nil
    )
    
    override func setUp() {
        engine = EngineMocks()
        let stub = UserNotificationCenterTypeStub()
        let spy = UserNotificationCenterTypeSpy(realObject: stub)
        userNotificationCenter = (stub, spy)
        
        userPreferenceService = engine.makeUserPreferenceService()
    }
    
    func setUpSut(
        reminders: [NotificationMessage] = [.init(title: "Reminder", body: "Example")],
        celebrations: [NotificationMessage] = [.init(title: "Celebration", body: "Example")]
    ) {
        let completionExpectation = XCTestExpectation()
        sut = NotificationService(
            engine: engine,
            reminders: reminders,
            celebrations: celebrations,
            userNotificationCenter: userNotificationCenter.spy
        ) {
            completionExpectation.fulfill()
        }
        
        wait(for: [completionExpectation], timeout: 5)
        if (userPreferenceService.stub.getKey_returnValue as? Bool) == false {
            XCTAssertEqual(userNotificationCenter.spy.methodLog, [
                .removeAllPendingNotificationRequests
            ])
            userNotificationCenter.spy.methodLog.removeAll()
        }
    }
    
    func test_init_withStoredData() {
        // TODO: Fix this test
        userNotificationCenter.stub.requestAuthorization_returnValue = .success(true)
        userPreferenceService.stub.getKey_returnValue = true
        userPreferenceService.stub.getKey_returnValue = 30
        userPreferenceService.stub.getKey_returnValue = Date(date: "01/01/2023", time: "08:00:00")!
        userPreferenceService.stub.getKey_returnValue = Date(date: "01/01/2023", time: "09:00:00")!
        setUpSut()
        
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [
            .requestAuthorization,
            .setNotificationCategories(categories: [
                .init(identifier: "com.rehydrate.reminder",
                      actions: [.init(identifier: "small",title: "small (-999)")],
                      intentIdentifiers: ["small"])
            ]),
            .pendingNotificationRequests,
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest)
        ])
    }
    
    func test_init_withNoStoredData() async {
        setUpSut()
        
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [
            .removeAllPendingNotificationRequests
        ])
    }
    
    func test_enable_success() async {
        userNotificationCenter.stub.requestAuthorization_returnValue = .success(true)
        setUpSut()
        let dates = getDates(start: "08:00:00", stop: "10:00:00")
        let result = await sut.enable(withFrequency: 60, start: dates.start, stop: dates.stop)
        
        assertResult(given: result, expected: .success(Void()))
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [
            .removeAllPendingNotificationRequests,
            .requestAuthorization,
            .setNotificationCategories(categories: [
                .init(identifier: "com.rehydrate.reminder",
                      actions: [.init(identifier: "small",title: "small (-999)")],
                      intentIdentifiers: ["small"])
            ]),
            .pendingNotificationRequests,
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest)
        ])
    }
    
    func test_enable_withMissingReminders() async {
        userNotificationCenter.stub.requestAuthorization_returnValue = .success(true)
        setUpSut(reminders: [])
        let dates = getDates(start: "08:00:00", stop: "10:00:00")
        let result = await sut.enable(
            withFrequency: 60,
            start: dates.start,
            stop: dates.stop
        )
        
        assertResult(given: result, expected: .success(Void()))
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [
            .removeAllPendingNotificationRequests,
            .requestAuthorization,
            .setNotificationCategories(categories: [
                .init(identifier: "com.rehydrate.reminder",
                      actions: [.init(identifier: "small",title: "small (-999)")],
                      intentIdentifiers: ["small"])
            ]),
            .pendingNotificationRequests
        ])
    }
    
    func test_enable_deniedAuth() async {
        userNotificationCenter.stub.requestAuthorization_returnValue = .success(false)
        setUpSut()
        let dates = getDates(start: "08:00:00", stop: "10:00:00")
        let result = await sut.enable(withFrequency: 60, start: dates.start, stop: dates.stop)
        
        assertResult(given: result, expected: .failure(.unauthorized))
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [
            .removeAllPendingNotificationRequests,
            .requestAuthorization
        ])
    }
    
    func test_enable_unauthorized() async {
        userNotificationCenter.stub.requestAuthorization_returnValue = .failure(NotificationError.unauthorized)
        setUpSut()
        let dates = getDates(start: "08:00:00", stop: "10:00:00")
        let result = await sut.enable(withFrequency: 60, start: dates.start, stop: dates.stop)
        
        assertResult(given: result, expected: .failure(.unauthorized))
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [
            .removeAllPendingNotificationRequests,
            .requestAuthorization
        ])
    }
    
    func test_enable_twice() async {
        userNotificationCenter.stub.requestAuthorization_returnValue = .success(true)
        setUpSut()
        let dates = getDates(start: "08:00:00", stop: "10:00:00")
        let result = await sut.enable(
            withFrequency: 60,
            start: dates.start,
            stop: dates.stop
        )
        
        let secondResult = await sut.enable(
            withFrequency: 60,
            start: dates.start,
            stop: dates.stop
        )
        
        assertResult(given: result, expected: .success(Void()))
        assertResult(given: secondResult, expected: .success(Void()))
        
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [
            .removeAllPendingNotificationRequests,
            .requestAuthorization,
            .setNotificationCategories(categories: [
                .init(identifier: "com.rehydrate.reminder",
                      actions: [.init(identifier: "small",title: "small (-999)")],
                      intentIdentifiers: ["small"])
            ]),
            .pendingNotificationRequests,
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest),
            .pendingNotificationRequests,
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest),
        ])
    }
    
    func test_enable_failedStoring() async {
        userNotificationCenter.stub.requestAuthorization_returnValue = .success(true)
        userPreferenceService.stub.setValueKey_returnValue = TestingError.mock
        setUpSut()
        let dates = getDates(start: "08:00:00", stop: "10:00:00")
        let result = await sut.enable(withFrequency: 60, start: dates.start, stop: dates.stop)
        
        assertResult(given: result, expected: .success(Void()))
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [
            .removeAllPendingNotificationRequests,
            .requestAuthorization,
            .setNotificationCategories(categories: [
                .init(identifier: "com.rehydrate.reminder",
                      actions: [.init(identifier: "small",title: "small (-999)")],
                      intentIdentifiers: ["small"])
            ]),
            .pendingNotificationRequests,
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest),
            .add(request: dummyNotificationRequest),
        ])
    }
    
    func test_enable_extremelyHighFrequency() async {
        userNotificationCenter.stub.requestAuthorization_returnValue = .success(true)
        setUpSut()
        let dates = getDates(start: "08:00:00", stop: "10:00:00")
        let result = await sut.enable(withFrequency: 999999999999999999,
                                      start: dates.start,
                                      stop: dates.stop)
        
        assertResult(given: result, expected: .success(Void()))
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [
            .removeAllPendingNotificationRequests,
            .requestAuthorization,
            .setNotificationCategories(categories: [
                .init(identifier: "com.rehydrate.reminder",
                      actions: [.init(identifier: "small",title: "small (-999)")],
                      intentIdentifiers: ["small"])
            ]),
            .pendingNotificationRequests,
            .add(request: dummyNotificationRequest),
        ])
    }
    
    func test_enable_extremelyLowFrequency() async {
        userNotificationCenter.stub.requestAuthorization_returnValue = .success(true)
        userPreferenceService.stub.getKey_returnValue = false
        setUpSut()
        let dates = getDates(start: "08:00:00", stop: "10:00:00")
        let result = await sut.enable(withFrequency: 5,
                                      start: dates.start,
                                      stop: dates.stop)
        
        assertResult(given: result, expected: .failure(.frequencyTooLow))
        XCTAssertEqual(userNotificationCenter.spy.methodLog, [.removeAllPendingNotificationRequests])
    }
    
    func test_getSettings() {
        setUpSut()
        let settings = sut.getSettings()
        XCTAssertEqual(settings, .init(isOn: false, start: nil, stop: nil, frequency: nil))
    }
    
    func test_getSettings_withOldSettings() {
        // TODO: Fix this test
        setUpSut()
        userPreferenceService.stub.getKey_returnValue = true
        userPreferenceService.stub.getKey_returnValue = 30
        userPreferenceService.stub.getKey_returnValue = Date(date: "01/01/2023", time: "08:00:00")!
        userPreferenceService.stub.getKey_returnValue = Date(date: "01/01/2023", time: "09:00:00")!
        let settings = sut.getSettings()
        XCTAssertEqual(settings, .init(isOn: true, 
                                       start: Date(date: "01/01/2023", time: "08:00:00"),
                                       stop: Date(date: "01/01/2023", time: "09:00:00"),
                                       frequency: 30))
    }
}

enum TestingError: Error {
    case mock
}

private extension NotificationServiceTests {
    func getDates(start: String, stop: String,
                  file: StaticString = #file, 
                  line: UInt = #line) -> (start: Date, stop: Date) {
        guard
            let startDate = Date(date: "01/01/2023", time: start),
            let stopDate = Date(date: "01/01/2023", time: stop)
        else {
            XCTAssert(false, "Unable to create test dates",
                      file: file, line: line)
            return (.now, .distantPast)
        }
        return (startDate, stopDate)
    }
    
    func assertResult(given: Result<Void, NotificationError>,
                      expected: Result<Void, NotificationError>,
                      file: StaticString = #file,
                      line: UInt = #line) {
        switch (given, expected) {
        case (.success, .success):
            XCTAssertTrue(true, file: file, line: line)
        case (.failure(let givenError), .failure(let expectedError)):
            XCTAssertEqual(givenError, expectedError, file: file, line: line)
            break
        case (.failure, .success), (.success, .failure):
            XCTAssert(false, "Given result (\(given) expected (\(expected)",
                      file: file, line: line)
        }
    }
    
    func assertNotificationTimes(givenRequests: [NotificationRequest],
                                 expectedTimes: [String],
                                 file: StaticString = #file,
                                 line: UInt = #line) {
        let givenTimes = givenRequests.compactMap { $0.trigger?.date?.toTimeString() }
        XCTAssertEqual(givenTimes, expectedTimes, file: file, line: line)
    }
}

extension NotificationError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unauthorized:
            "unauthorized"
        case .invalidDate:
            "invalidDate"
        case .missingDateComponents:
            "missingDateComponents"
        case .missingReminders:
            "missingReminders"
        case .missingCongratulations:
            "missingCongratulations"
        case .frequencyTooLow:
            "frequencyTooLow"
        case .alreadySet(at: let date):
            "alreadySet \(date.description)"
        }
    }
}

extension UserNotificationCenterTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .requestAuthorization:
            "requestAuthorization"
        case .setNotificationCategories(let categories):
            "setNotificationCategories: \(categories.description)"
        case .notificationCategories:
            "notificationCategories"
        case .add:
            "add"
        case .pendingNotificationRequests:
            "pendingNotificationRequests"
        case .removePendingNotificationRequests(let identifiers):
            "removePendingNotificationRequests with \(identifiers)"
        case .removeAllPendingNotificationRequests:
            "removeAllPendingNotificationRequests"
        case .deliveredNotifications:
            "deliveredNotifications"
        case .removeDeliveredNotifications(let identifiers):
            "removeDeliveredNotifications with \(identifiers)"
        case .removeAllDeliveredNotifications:
            "removeAllDeliveredNotifications"
        case .setBadgeCount:
            "setBadgeCount"
        }
    }
}
extension UserNotificationCenterTypeSpy.MethodCall: Equatable {
    public static func == (lhs: UserNotificationCenterTypeSpy.MethodCall, rhs: UserNotificationCenterTypeSpy.MethodCall) -> Bool {
        switch (lhs, rhs) {
        case (.requestAuthorization, .requestAuthorization),
            (.notificationCategories, .notificationCategories),
            (.deliveredNotifications, .deliveredNotifications),
            (.pendingNotificationRequests, .pendingNotificationRequests),
            (.removeAllDeliveredNotifications, .removeAllDeliveredNotifications),
            (.removeAllPendingNotificationRequests, .removeAllPendingNotificationRequests):
            true
        case (.add, .add):
//            lhsRequest == rhsRequest
            true
        case (.setNotificationCategories(let lhsCategories), .setNotificationCategories(let rhsCategories)):
            lhsCategories == rhsCategories
        case (.removePendingNotificationRequests(let lhsIdentifiers), .removePendingNotificationRequests(let rhsIdentifiers)):
            lhsIdentifiers == rhsIdentifiers
        case (.removeDeliveredNotifications(let lhsIdentifiers), .removeDeliveredNotifications(let rhsIdentifiers)):
            lhsIdentifiers == rhsIdentifiers
        case (.setBadgeCount(let lhsNewBadgeCount), .setBadgeCount(let rhsNewBadgeCount)):
            lhsNewBadgeCount == rhsNewBadgeCount
        default:
            false
        }
    }
}

extension NotificationRequest: Equatable {
    public static func == (lhs: NotificationRequest, rhs: NotificationRequest) -> Bool {
        lhs.identifier == rhs.identifier &&
        lhs.content == rhs.content &&
        lhs.trigger == rhs.trigger
    }
}

extension NotificationContent: Equatable {
    public static func == (lhs: NotificationContent, rhs: NotificationContent) -> Bool {
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.body == rhs.body &&
        lhs.userInfo.debugDescription == rhs.userInfo.debugDescription &&
        lhs.categoryIdentifier == rhs.categoryIdentifier
    }
}

extension NotificationTrigger: Equatable {
    public static func == (lhs: NotificationTrigger, rhs: NotificationTrigger) -> Bool {
        lhs.repeats == rhs.repeats &&
        lhs.dateComponents == rhs.dateComponents &&
        lhs.date == rhs.date
    }
}

extension NotificationSettings: CustomStringConvertible {
    public var description: String {
        return if let start, let stop, let frequency {
            "isOn: \(isOn), start: \(start), stop: \(stop), frequency: \(frequency)"
        } else {
            "isOn: \(isOn)"
        }
    }
}

extension NotificationSettings: Equatable {
    public static func == (lhs: NotificationSettings, rhs: NotificationSettings) -> Bool {
        lhs.isOn == rhs.isOn &&
        lhs.start == rhs.start &&
        lhs.stop == rhs.stop &&
        lhs.frequency == rhs.frequency
    }
}

extension Date {
    init?(date: String, time: String) {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_GB")
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        guard let date = formatter.date(from: "\(date) \(time)")
        else { return nil }
        self = date
    }
    
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_GB")
        formatter.dateFormat = "hh:mm:ss"
        return formatter.string(from: self)
    }
}

//
//  NotificationServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/09/2023.
//

import XCTest
import EngineMocks
import LoggingService
import UserPreferenceServiceMocks
import UserPreferenceServiceInterface
import NotificationServiceMocks
import NotificationServiceInterface
@testable import NotificationService
import UserNotifications

final class NotificationServiceTests: XCTestCase {
    typealias Engine = (
        HasLoggingService &
        HasUserPreferenceService
    )
    
    var engine: Engine = EngineMocks()
    
    var notificationCenter: (stub: NotificationCenterStub, spy: NotificationCenterSpy)!
    var userPreferenceService: UserPreferenceServiceStub!
    
    var sut: NotificationServiceType!
    
    override func setUp() {
        let stub = NotificationCenterStub()
        let spy = NotificationCenterSpy(realObject: stub)
        notificationCenter = (stub, spy)
        
        userPreferenceService = UserPreferenceServiceStub()
        engine.userPreferenceService = userPreferenceService
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
            notificationCenter: notificationCenter.spy,
            notificationOptions: .alert
        ) {
            completionExpectation.fulfill()
        }
        
        wait(for: [completionExpectation], timeout: 5)
        if userPreferenceService.get_returnValue.description ==
            ["notification-is-enabled": false].description {
            XCTAssertEqual(notificationCenter.spy.methodLog, [
                .removeAllPendingNotificationRequests
            ])
            notificationCenter.spy.methodLog.removeAll()
        }
    }
    
    func test_init_withStoredData() {
        userPreferenceService.get_returnValue = [
            "notification-is-enabled": true,
            "notification-frequency": 30,
            "notification-start": Date(date: "01/01/2023", time: "08:00:00")!,
            "notification-stop": Date(date: "01/01/2023", time: "09:00:00")!
        ]
        setUpSut()
        
        XCTAssertEqual(notificationCenter.spy.methodLog, [
            .requestAuthorization,
            .pendingNotificationRequests, 
            .add,
            .add,
            .add
        ])
    }
    
    func test_init_withNoStoredData() async {
        setUpSut()
        
        XCTAssertEqual(notificationCenter.spy.methodLog, [])
    }
    
    func test_enable_success() async {
        setUpSut()
        let result = await sut.enable(withFrequency: 60,
                                      startTime: "08:00:00",
                                      stopTime: "10:00:00")
        
        assertResult(given: result, expected: .success(Void()))
        XCTAssertEqual(notificationCenter.spy.methodLog, [
            .requestAuthorization,
            .pendingNotificationRequests,
            .add, .add, .add
        ])
        
        let notifications = await notificationCenter.stub.pendingNotificationRequests()
        assertNotificationTimes(givenRequests: notifications,
                                expectedTimes: ["08:00:00", "09:00:00", "10:00:00"])
    }
    
    func test_enable_withMissingReminders() async {
        setUpSut(reminders: [])
        let result = await sut.enable(
            withFrequency: 60,
            startTime: "08:00:00",
            stopTime: "10:00:00"
        )
        
        assertResult(given: result, expected: .success(Void()))
        XCTAssertEqual(notificationCenter.spy.methodLog, [
            .requestAuthorization,
            .pendingNotificationRequests
        ])
        
        let notifications = await notificationCenter.stub.pendingNotificationRequests()
        assertNotificationTimes(givenRequests: notifications, expectedTimes: [])
    }
    
    func test_enable_deniedAuth() async {
        notificationCenter.stub.requestAuthorization = .success(false)
        setUpSut()
        let result = await sut.enable(withFrequency: 60, 
                                      startTime: "08:00:00",
                                      stopTime: "10:00:00")
        
        assertResult(given: result, expected: .failure(.unauthorized))
        XCTAssertEqual(notificationCenter.spy.methodLog, [
            .requestAuthorization
        ])
        
        let notifications = await notificationCenter.stub.pendingNotificationRequests()
        assertNotificationTimes(givenRequests: notifications,expectedTimes: [])
    }
    
    func test_enable_unauthorized() async {
        notificationCenter.stub.requestAuthorization = .failure(NotificationError.unauthorized)
        setUpSut()
        let result = await sut.enable(withFrequency: 60,
                                      startTime: "08:00:00",
                                      stopTime: "10:00:00")
        
        assertResult(given: result, expected: .failure(.unauthorized))
        XCTAssertEqual(notificationCenter.spy.methodLog, [
            .requestAuthorization
        ])
        
        let notifications = await notificationCenter.stub.pendingNotificationRequests()
        assertNotificationTimes(givenRequests: notifications,expectedTimes: [])
    }
    
    func test_enable_twice() async {
        setUpSut()
        let result = await sut.enable(
            withFrequency: 60,
            startTime: "08:00:00",
            stopTime: "10:00:00"
        )
        
        let secondResult = await sut.enable(
            withFrequency: 60,
            startTime: "08:00:00",
            stopTime: "10:00:00"
        )
        
        assertResult(given: result, expected: .success(Void()))
        assertResult(given: secondResult, expected: .success(Void()))
        
        XCTAssertEqual(notificationCenter.spy.methodLog, [
            .requestAuthorization,
            .pendingNotificationRequests, 
            .add,
            .add,
            .add,
            .pendingNotificationRequests
        ])
        
        let notifications = await notificationCenter.stub.pendingNotificationRequests()
        assertNotificationTimes(givenRequests: notifications, 
                                expectedTimes: ["08:00:00", "09:00:00", "10:00:00"])
    }
    
    func test_enable_failedStoring() async {
        userPreferenceService.set_returnError = TestingError.mock
        setUpSut()
        let result = await sut.enable(withFrequency: 60,
                                      startTime: "08:00:00",
                                      stopTime: "10:00:00")
        
        assertResult(given: result, expected: .success(Void()))
        XCTAssertEqual(notificationCenter.spy.methodLog, [
            .removeAllPendingNotificationRequests,
            .requestAuthorization,
            .pendingNotificationRequests, 
            .add,
            .add,
            .add
        ])
        
        let notifications = await notificationCenter.stub.pendingNotificationRequests()
        assertNotificationTimes(givenRequests: notifications,
                                expectedTimes: ["08:00:00", "09:00:00", "10:00:00"])
    }
    
    func test_enable_extremelyHighFrequency() async {
        setUpSut()
        let result = await sut.enable(withFrequency: 999999999999999999,
                                      startTime: "08:00:00",
                                      stopTime: "10:00:00")
        
        assertResult(given: result, expected: .success(Void()))
        XCTAssertEqual(notificationCenter.spy.methodLog, [
            .requestAuthorization,
            .pendingNotificationRequests, .add
        ])
        
        let notifications = await notificationCenter.stub.pendingNotificationRequests()
        assertNotificationTimes(givenRequests: notifications,expectedTimes: ["08:00:00"])
    }
    
    func test_enable_extremelyLowFrequency() async {
        setUpSut()
        let result = await sut.enable(withFrequency: 1,
                                      startTime: "08:00:00",
                                      stopTime: "10:00:00")
        
        assertResult(given: result, expected: .failure(.frequencyTooLow))
        XCTAssertEqual(notificationCenter.spy.methodLog, [])
        
        let notifications = await notificationCenter.stub.pendingNotificationRequests()
        assertNotificationTimes(givenRequests: notifications,expectedTimes: [])
    }
    
    func test_getSettings() {
        setUpSut()
        let settings = sut.getSettings()
        XCTAssertEqual(settings, .init(isOn: false, start: nil, stop: nil, frequency: nil))
    }
    
    func test_getSettings_withOldSettings() {
        userPreferenceService.get_returnValue = [
            "notification-is-enabled": true,
            "notification-frequency": 30,
            "notification-start": Date(date: "01/01/2023", time: "08:00:00")!,
            "notification-stop": Date(date: "01/01/2023", time: "09:00:00")!
        ]
        setUpSut()
        let settings = sut.getSettings()
        XCTAssertEqual(settings, .init(isOn: true, start: "08:00:00", stop: "09:00:00", frequency: 30))
    }
}

enum TestingError: Error {
    case mock
}

private extension NotificationServiceTests {
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
    
    func assertNotificationTimes(givenRequests: [UNNotificationRequest],
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

extension NotificationCenterSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .requestAuthorization:
            "requestAuthorization"
        case .setNotificationCategories:
            "setNotificationCategories"
        case .notificationCategories:
            "notificationCategories"
        case .add:
            "add"
        case .pendingNotificationRequests:
            "pendingNotificationRequests"
        case .removePendingNotificationRequests:
            "removePendingNotificationRequests"
        case .removeAllPendingNotificationRequests:
            "removeAllPendingNotificationRequests"
        case .deliveredNotifications:
            "deliveredNotifications"
        case .removeDeliveredNotifications:
            "removeDeliveredNotifications"
        case .removeAllDeliveredNotifications:
            "removeAllDeliveredNotifications"
        case .setBadgeCount:
            "setBadgeCount"
        }
    }
}

extension NotificationSettings: CustomStringConvertible {
    public var description: String {
        "isOn: \(isOn), start: \(start ?? "NA"), stop: \(stop ?? "NA"), frequency: \(frequency ?? 0)"
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

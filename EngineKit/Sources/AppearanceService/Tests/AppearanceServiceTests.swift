//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 04/11/2023.
//

import XCTest
import EngineMocks
import TestHelper
import LoggingService
import UserPreferenceServiceInterface
import UserPreferenceServiceMocks
import PortsInterface
import PortsMocks
import AppearanceServiceInterface
@testable import AppearanceService

final class AppearanceServiceTests: XCTestCase {
    typealias Engine = (
        HasLoggingService &
        HasUserPreferenceService &
        HasPorts
    )
    
    var engine: Engine!
    
    var appearancePort: AppearancePortStub!
    var userPreferenceService: UserPreferenceServiceTypeStub!
    var preferenceKey: String!
    
    var sut: AppearanceServiceType!
    
    override func setUp() {
        appearancePort = AppearancePortStub()
        userPreferenceService = UserPreferenceServiceTypeStub()
        engine = EngineMocks()
        engine.appearancePort = appearancePort
        engine.userPreferenceService = userPreferenceService
        let service = AppearanceService(engine: engine)
        sut = service
        preferenceKey = service.preferenceKey
    }
    
    func test_getAppearance() {
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_getAppearance_withSaved() {
        userPreferenceService.getKey_returnValue = [
            preferenceKey: "dark"
        ]
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .dark)
    }
    
    func test_getAppearance_withNoSavedWithLightCurrent() {
        appearancePort.getStyle_returnValue = .light
        userPreferenceService.getKey_returnValue = [
            preferenceKey: ""
        ]
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_getAppearance_withNoSavedWithDarkCurrent() {
        appearancePort.getStyle_returnValue = .dark
        userPreferenceService.getKey_returnValue = [
            preferenceKey: ""
        ]
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .dark)
    }
    
    func test_getAppearance_withNoSavedAndUnknownCurrent() {
        appearancePort.getStyle_returnValue = .none
        userPreferenceService.getKey_returnValue = [
            preferenceKey: ""
        ]
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_setAppearance_light() {
        sut.setAppearance(.light)
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_setAppearance_dark() {
        sut.setAppearance(.dark)
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .dark)
    }
    
    func test_setAppearance_setFails() {
        appearancePort.setStyle_returnValue = MockError.some
        sut.setAppearance(.dark)
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_setAppearance_storingFails() {
        userPreferenceService.setValueKey_returnValue = MockError.some
        sut.setAppearance(.dark)
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_setAppearance_fails() {
        appearancePort.setStyle_returnValue = MockError.some
        userPreferenceService.setValueKey_returnValue = MockError.some
        sut.setAppearance(.dark)
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
}

extension AppearanceServiceTests {
    enum MockError: Error {
        case some
    }
}

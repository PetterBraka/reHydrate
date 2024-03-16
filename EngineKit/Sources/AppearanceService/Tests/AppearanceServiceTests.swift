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
    var engine: EngineMocks!
    
    var appearancePort: (stub: AppearancePortTypeStubbing, spy: AppearancePortTypeSpying)!
    var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    
    var sut: AppearanceServiceType!
    
    override func setUp() {
        engine = EngineMocks()
        appearancePort = engine.makeAppearancePort()
        userPreferenceService = engine.makeUserPreferenceService()
        sut = AppearanceService(engine: engine)
    }
    
    func test_getAppearance() {
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_getAppearance_withSaved() {
        userPreferenceService.stub.getKey_returnValue = "dark"
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .dark)
    }
    
    func test_getAppearance_withNoSavedWithLightCurrent() {
        appearancePort.stub.getStyle_returnValue = .light
        userPreferenceService.stub.getKey_returnValue = ""
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_getAppearance_withNoSavedWithDarkCurrent() {
        appearancePort.stub.getStyle_returnValue = .dark
        userPreferenceService.stub.getKey_returnValue =  ""
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .dark)
    }
    
    func test_getAppearance_withNoSavedAndUnknownCurrent() {
        appearancePort.stub.getStyle_returnValue = .none
        userPreferenceService.stub.getKey_returnValue =  ""
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
        XCTAssertEqual(userPreferenceService.spy.methodLog, [.set_for])
    }
    
    func test_setAppearance_setFails() {
        appearancePort.stub.setStyleStyle_returnValue = MockError.some
        sut.setAppearance(.dark)
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_setAppearance_storingFails() {
        userPreferenceService.stub.setValueKey_returnValue = MockError.some
        sut.setAppearance(.dark)
        let appearance = sut.getAppearance()
        XCTAssertEqual(appearance, .light)
    }
    
    func test_setAppearance_fails() {
        appearancePort.stub.setStyleStyle_returnValue = MockError.some
        userPreferenceService.stub.setValueKey_returnValue = MockError.some
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

//
//  LanguageServiceTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 03/09/2023.
//

import XCTest
import LanguageServiceInterface
import EngineMocks
import UserPreferenceServiceMocks
@testable import LanguageService

final class LanguageServiceTests: XCTestCase {
    var sut: LanguageService!
    var userPreferenceService: UserPreferenceServiceStub!
    
    override func setUp() {
        let engine = EngineMocks()
        self.userPreferenceService = UserPreferenceServiceStub()
        engine.userPreferenceService = userPreferenceService
        self.sut = LanguageService(engine: engine)
    }
    
    func test_setLanguage() {
        sut.setLanguage(to: .norwegian)
        XCTAssertEqual(sut.currentLanguage, .norwegian)
    }
    
    func test_setLanguage_failure() {
        userPreferenceService.set_returnError = DummyError.setLanguage
        sut.setLanguage(to: .norwegian)
        XCTAssertNotEqual(sut.currentLanguage, .english)
    }
    
    func test_getSelectedLanguage() {
        let language = sut.getSelectedLanguage()
        XCTAssertEqual(language, .english)
    }
    
    func test_getSelectedLanguage_storedLanguage() {
        userPreferenceService.get_returnValue = [
            "LanguageService.Language": Language.norwegian
        ]
        let language = sut.getSelectedLanguage()
        XCTAssertEqual(language, .norwegian)
    }
    
    func test_getLanguageOptions() {
        let options = sut.getLanguageOptions()
        XCTAssertEqual(options.count, 4)
    }
}

extension LanguageServiceTests {
    enum DummyError: Error {
        case setLanguage
    }
}

//
//  HomePresentationTests.swift
//  
//
//  Created by Petter vang Brakalsvålet on 24/02/2024.
//

import XCTest
import EngineMocks
@testable import PresentationKit

final class HomePresentationTests: XCTestCase {
    private var sut: Screen.Home.Presenter!

    override func setUp() {
        let engine = EngineMocks()
        sut = Screen.Home.Presenter(
            engine: engine,
            router: Router()
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
}
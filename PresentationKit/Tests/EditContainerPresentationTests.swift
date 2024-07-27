//
//  EditContainerPresentationTests.swift
//
//
//  Created by Petter vang Brakalsvålet on 24/02/2024.
//

import XCTest
import TestHelper
import EngineMocks
import DrinkServiceInterface
import DrinkServiceMocks
import UnitService
import UnitServiceInterface
import UserPreferenceServiceMocks
@testable import PresentationKit

final class EditContainerPresentationTests: XCTestCase {
    private typealias Sut = Screen.EditContainer.Presenter
    
    private var engine: EngineMocks!
    private var router: RouterSpy!
    
    private var drinkService: (stub: DrinkServiceTypeStubbing, spy: DrinkServiceTypeSpying)!
    private var userPreferenceService: (stub: UserPreferenceServiceTypeStubbing, spy: UserPreferenceServiceTypeSpying)!
    
    override func setUp() async throws {
        router = RouterSpy()
        engine = EngineMocks()
        drinkService = engine.makeDrinksService()
        userPreferenceService = engine.makeUserPreferenceService()
        engine.unitService = UnitService(engine: engine)
    }
    
    override func tearDown() {
        router = nil
        engine = nil
        drinkService = nil
        userPreferenceService = nil
    }
    
    func test_didAppear() async {
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didAppear)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                  selectedDrink: .init(size: 300, container: .small),
                  editedSize: 300,
                  editedFill: 0.75,
                  error: .none)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didAppear_imperial() async {
        userPreferenceService.stub.getKey_returnValue = UnitSystem.imperial
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didAppear)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                  selectedDrink: .init(size: 10.56, container: .small),
                  editedSize: 10.56,
                  editedFill: 0.75,
                  error: .none)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didTapCancel() async {
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didTapCancel)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                                     selectedDrink: .init(size: 300, container: .small),
                                     editedSize: 0,
                                     editedFill: 0,
                                     error: .none))
        XCTAssertEqual(router.log, [.close])
    }
    
    func test_didTapCancel_afterDidAppear() async {
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didAppear)
        await sut.perform(action: .didTapCancel)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                  selectedDrink: .init(size: 300, container: .small),
                  editedSize: 300,
                  editedFill: 0.75,
                  error: .none)
        )
        XCTAssertEqual(router.log, [.close])
    }
    
    func test_didChangeSize() async {
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didChangeSize(size: 400))
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                                     selectedDrink: .init(size: 300, container: .small),
                                     editedSize: 400,
                                     editedFill: 1,
                                     error: .none)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didChangeSize_didSave() async {
        let sut = Sut(engine: engine, router: router, selectedDrink: Drink(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didChangeSize(size: 400))
        await sut.perform(action: .didTapSave)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                                     selectedDrink: .init(size: 300, container: .small),
                                     editedSize: 400,
                                     editedFill: 1,
                                     error: .none)
        )
        XCTAssertEqual(router.log, [.close])
        assert(
            givenCall: drinkService.spy.lastMethodCall,
            expectedCall: .edit(size: 400, drink: Drink(id: "", size: 300, container: .small))
        )
    }
    
    func test_didChangeSize_didSaveFailed() async {
        drinkService.stub.editSizeDrink_returnValue = .failure(DummyError())
        
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didChangeSize(size: 400))
        await sut.perform(action: .didTapSave)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                                     selectedDrink: .init(size: 300, container: .small),
                                     editedSize: 400,
                                     editedFill: 1,
                                     error: .failedSaving)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didChangeSize_imperial() async {
        userPreferenceService.stub.getKey_returnValue = UnitSystem.imperial
        userPreferenceService.stub.getKey_returnValue = UnitSystem.imperial
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didChangeSize(size: 14.08))
        await sut.perform(action: .didTapSave)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                                     selectedDrink: .init(size: 300, container: .small),
                                     editedSize: 14.08,
                                     editedFill: 1,
                                     error: .none)
        )
        XCTAssertEqual(router.log, [.close])
        assert(
            givenCall: drinkService.spy.lastMethodCall,
            expectedCall: .edit(size: 400, drink: Drink(id: "", size: 300, container: .small)),
            accuracy: 1
        )
    }
    
    func test_didChangeFill() async {
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didChangeFill(fill: 0.5))
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                                     selectedDrink: .init(size: 300, container: .small),
                                     editedSize: 200,
                                     editedFill: 0.5,
                                     error: .none)
        )
        XCTAssertEqual(router.log, [])
    }
    
    func test_didChangeFill_didSave() async {
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didChangeFill(fill: 0.5))
        await sut.perform(action: .didTapSave)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                                     selectedDrink: .init(size: 300, container: .small),
                                     editedSize: 200,
                                     editedFill: 0.5,
                                     error: .none)
        )
        XCTAssertEqual(router.log, [.close])
        assert(
            givenCall: drinkService.spy.lastMethodCall,
            expectedCall:.edit(size: 200, drink: Drink(id: "", size: 300, container: .small))
        )
    }
    
    func test_didChangeFill_didSaveFailed() async {
        drinkService.stub.editSizeDrink_returnValue = .failure(DummyError())
        
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didChangeFill(fill: 0.5))
        await sut.perform(action: .didTapSave)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                                     selectedDrink: .init(size: 300, container: .small),
                                     editedSize: 200,
                                     editedFill: 0.5,
                                     error: .failedSaving)
        )
        XCTAssertEqual(router.log, [])
        assert(
            givenCall: drinkService.spy.lastMethodCall,
            expectedCall: .edit(size: 200, drink: Drink(id: "", size: 300, container: .small))
        )
    }
    
    func test_didChangeFill_imperial() async {
        userPreferenceService.stub.getKey_returnValue = UnitSystem.imperial
        userPreferenceService.stub.getKey_returnValue = UnitSystem.imperial
        
        let sut = Sut(engine: engine, router: router, selectedDrink: .init(id: "", size: 300, container: .small), didSavingChanges: nil)
        await sut.perform(action: .didChangeFill(fill: 0.5))
        await sut.perform(action: .didTapSave)
        
        assert(
            givenViewModel: sut.viewModel,
            expectedViewModel: .init(isSaving: false,
                                     selectedDrink: .init(size: 300, container: .small),
                                     editedSize: 7.04,
                                     editedFill: 0.5,
                                     error: .none)
        )
        XCTAssertEqual(router.log, [.close])
        assert(
            givenCall: drinkService.spy.lastMethodCall,
            expectedCall: .edit(size: 200, drink: Drink(id: "", size: 300, container: .small))
        )
    }
}

extension EditContainerPresentationTests {
    private func assert(
        givenViewModel: Sut.ViewModel,
        expectedViewModel: Sut.ViewModel,
        accuracy: Double = 0.01,
        file: StaticString = #file, line: UInt = #line
    ) {
        XCTAssertEqual(
            givenViewModel.isSaving, expectedViewModel.isSaving,
            "isSaving", file: file, line: line
        )
        XCTAssertEqual(
            givenViewModel.selectedDrink.size, expectedViewModel.selectedDrink.size, accuracy: accuracy,
            "selectedDrink.size", file: file, line: line
        )
        XCTAssertEqual(
            givenViewModel.selectedDrink.container, expectedViewModel.selectedDrink.container,
            "selectedDrink.container", file: file, line: line
        )
        XCTAssertEqual(
            givenViewModel.editedSize, expectedViewModel.editedSize, accuracy: accuracy,
            "editedSize", file: file, line: line
        )
        XCTAssertEqual(
            givenViewModel.editedFill, expectedViewModel.editedFill, accuracy: accuracy,
            "editedFill", file: file, line: line
        )
        
        XCTAssertEqual(
            givenViewModel.error, expectedViewModel.error,
            "error", file: file, line: line
        )
    }
}

private extension EditContainerPresentationTests {
    func assert(givenCall: DrinkServiceTypeSpy.MethodCall?, expectedCall: DrinkServiceTypeSpy.MethodCall,
                accuracy: Double = 0.01,
                file: StaticString = #file, line: UInt = #line) {
        switch (givenCall, expectedCall) {
        case let (.add(givenSize, givenContainer), .add(expectedSize, expectedContainer)):
            XCTAssertEqual(givenSize, expectedSize, accuracy: accuracy, file: file, line: line)
            XCTAssertEqual(givenContainer, expectedContainer, file: file, line: line)
        case let (.edit(givenSize, givenDrink), .edit(expectedSize, expectedDrink)):
            XCTAssertEqual(givenSize, expectedSize, accuracy: accuracy, file: file, line: line)
            XCTAssertEqual(givenDrink, expectedDrink, file: file, line: line)
        case let (.remove(givenContainer), .remove(expectedContainer)):
            XCTAssertEqual(givenContainer, expectedContainer)
        case (.getSaved, .getSaved), (.resetToDefault, .resetToDefault):
            XCTAssertTrue(true, file: file, line: line)
        case (.add, .edit),
            (.add, .remove),
            (.add, .getSaved),
            (.add, .resetToDefault),
            (.edit, .add),
            (.edit, .remove),
            (.edit, .getSaved),
            (.edit, .resetToDefault),
            (.remove, .add),
            (.remove, .edit),
            (.remove, .getSaved),
            (.remove, .resetToDefault),
            (.getSaved, .add),
            (.getSaved, .edit),
            (.getSaved, .remove),
            (.getSaved, .resetToDefault),
            (.resetToDefault, .add),
            (.resetToDefault, .edit),
            (.resetToDefault, .remove),
            (.resetToDefault, .getSaved),
            (.none, .add),
            (.none, .edit),
            (.none, .remove),
            (.none, .getSaved),
            (.none, .resetToDefault):
            XCTFail("\(String(describing: givenCall)), is not \(expectedCall)", file: file, line: line)
        }
    }
}

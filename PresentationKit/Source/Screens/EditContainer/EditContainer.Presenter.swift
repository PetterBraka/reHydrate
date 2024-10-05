//
//  EditContainer.swift
//
//
//  Created by Petter vang Brakalsvålet on 14/10/2023.
//

import Foundation
import LoggingService
import PresentationInterface
import DrinkServiceInterface
import UnitServiceInterface
import PhoneCommsInterface

extension Screen.EditContainer {
    public final class Presenter: EditContainerPresenterType {
        public typealias ViewModel = EditContainer.ViewModel
        public typealias Engine = (
            HasLoggingService &
            HasDrinksService &
            HasUnitService &
            HasPhoneComms
        )
        public typealias Router = (
            EditContainerRoutable
        )
        
        private let engine: Engine
        private let router: Router
        
        public weak var scene: EditContainerSceneType?
        
        public private(set) var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        private let selectedDrink: Drink
        
        private var containerRanger: (min: Int, max: Int) {
            switch selectedDrink.container {
            case .small: (100, 400)
            case .medium: (300, 700)
            case .large: (500, 1200)
            case .health: (100, 1500)
            }
        }
        
        public init(engine: Engine,
                    router: Router,
                    selectedDrink: Drink) {
            self.engine = engine
            self.router = router
            self.selectedDrink = selectedDrink
            
            self.viewModel = .init(
                isSaving: false,
                selectedDrink: .init(from: selectedDrink),
                editedSize: 0,
                editedFill: 0,
                error: nil
            )
        }
        
        public func perform(action: EditContainer.Action) async {
            switch action {
            case .didAppear:
                let unitSystem = engine.unitService.getUnitSystem()
                let unit: UnitModel = unitSystem == .metric ? .millilitres : .ounces
                let max = engine.unitService.convert(Double(containerRanger.max), from: .millilitres, to: unit)
                let size = engine.unitService.convert(selectedDrink.size, from: .millilitres, to: unit)
                
                updateViewModel(
                    isSaving: false,
                    selectedDrink: getLocalDrink(fromMetricDrink: selectedDrink, using: unitSystem),
                    editedSize: size,
                    editedFill: size / max,
                    error: nil
                )
            case .didTapSave:
                updateViewModel(isSaving: true)
                do {
                    let unitSystem = engine.unitService.getUnitSystem()
                    let unit: UnitModel = unitSystem == .metric ? .millilitres : .ounces
                    let size = engine.unitService.convert(viewModel.editedSize, from: unit, to: .millilitres)
                    let roundedSize = unitSystem == .metric ? size.rounded() : size
                    _ = try await engine.drinksService.edit(size: roundedSize, of: selectedDrink.container)
                    updateViewModel(isSaving: false)
                    router.close()
                    await engine.phoneComms.sendDataToWatch()
                } catch {
                    updateViewModel(isSaving: false, error: .failedSaving)
                }
            case .didTapCancel:
                router.close()
            case let .didChangeSize(size):
                let unitSystem = engine.unitService.getUnitSystem()
                let unit: UnitModel = unitSystem == .metric ? .millilitres : .ounces
                let max = engine.unitService.convert(Double(containerRanger.max), from: .millilitres, to: unit)
                let roundedSize = unitSystem == .metric ? size.rounded() : size
                updateViewModel(editedSize: size, editedFill: roundedSize / max)
            case let .didChangeFill(fill):
                let unitSystem = engine.unitService.getUnitSystem()
                let unit: UnitModel = unitSystem == .metric ? .millilitres : .ounces
                let max = engine.unitService.convert(Double(containerRanger.max), from: .millilitres, to: unit)
                let size = fill * max
                let roundedSize = unitSystem == .metric ? size.rounded() : fill * max
                updateViewModel(editedSize: roundedSize, editedFill: fill)
            }
        }
        
        func updateViewModel(
            isSaving: Bool? = nil,
            selectedDrink: ViewModel.Drink? = nil,
            editedSize: Double? = nil,
            editedFill: Double? = nil,
            error: ViewModel.EditContainerError? = nil
        ) {
            viewModel = .init(
                isSaving: isSaving ?? viewModel.isSaving,
                selectedDrink: selectedDrink ?? viewModel.selectedDrink,
                editedSize: editedSize ?? viewModel.editedSize,
                editedFill: editedFill ?? viewModel.editedFill,
                error: error
            )
        }
    }
}

private extension Screen.EditContainer.Presenter {
    func getLocalDrink(fromMetricDrink drink: Drink, using unitSystem: UnitSystem) -> ViewModel.Drink {
        let unit: UnitModel = unitSystem == .metric ? .millilitres : .ounces
        
        let localDrink = ViewModel.Drink(
            size: engine.unitService.convert(drink.size, from: .millilitres, to: unit),
            container: .init(from: drink.container)
        )
        
        return localDrink
    }
}

extension DrinkServiceInterface.Container {
    init(from container: EditContainer.ViewModel.Container) {
        switch container {
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        }
    }
}

extension EditContainer.ViewModel.Drink {
    init(from drink: DrinkServiceInterface.Drink) {
        self.init(size: drink.size, container: .init(from: drink.container))
    }
}

extension EditContainer.ViewModel.Container {
    init(from container: DrinkServiceInterface.Container) {
        switch container {
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        case .health:
            self = .large
        }
    }
}

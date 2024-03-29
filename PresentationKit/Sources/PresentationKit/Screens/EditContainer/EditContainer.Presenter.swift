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

extension Screen.EditContainer {
    public final class Presenter: EditContainerPresenterType {
        public typealias ViewModel = EditContainer.ViewModel
        public typealias Engine = (
            HasLoggingService &
            HasDrinksService &
            HasUnitService
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
        
        private let containerRanger: (min: Int, max: Int)
        private let didSavingChanges: (() -> Void)?
        
        public init(engine: Engine,
                    router: Router,
                    selectedDrink: Drink,
                    didSavingChanges: (() -> Void)?) {
            self.engine = engine
            self.router = router
            self.selectedDrink = selectedDrink
            self.containerRanger =
            switch selectedDrink.container {
            case .small: (100, 400)
            case .medium: (300, 700)
            case .large: (500, 1200)
            case .health: (100, 1500)
            }
            self.didSavingChanges = didSavingChanges
            
            self.viewModel = .init(
                isSaving: false,
                unit: .metric,
                selectedDrink: .init(from: selectedDrink),
                editedSize: selectedDrink.size,
                editedFill: 0.5,
                containerRange: Double(containerRanger.min)...Double(containerRanger.max),
                error: nil
            )
            updateViewModel(
                isSaving: false,
                unit: .init(from: engine.unitService.getUnitSystem()),
                editedFill: getFill(from: selectedDrink.size)
            )
        }
        
        public func perform(action: EditContainer.Action) async {
            switch action {
            case .didAppear:
                break
            case .didTapSave(let newSize):
                updateViewModel(isSaving: true)
                do {
                    let unit = engine.unitService.getUnitSystem()
                    let newSize = engine.unitService.convert(
                        newSize, 
                        from: unit == .metric ? .millilitres : .ounces,
                        to: .millilitres
                    )
                    _ = try await engine.drinksService.edit(size: newSize, of: selectedDrink)
                    try? await Task.sleep(for: .seconds(1))
                    updateViewModel(isSaving: false)
                    router.close()
                    didSavingChanges?()
                } catch {
                    updateViewModel(isSaving: false, error: .failedSaving)
                }
            case .didTapCancel:
                router.close()
            case let .didChangeSize(size):
                let fill = getFill(from: size)
                updateViewModel(editedSize: size, editedFill: fill)
            case let .didChangeFill(fill):
                let size = getSize(from: fill)
                updateViewModel(editedSize: size, editedFill: fill)
            }
        }
        
        func updateViewModel(
            isSaving: Bool? = nil,
            unit: EditContainer.ViewModel.UnitSystem? = nil,
            selectedDrink: ViewModel.Drink? = nil,
            editedSize: Double? = nil,
            editedFill: Double? = nil,
            error: ViewModel.EditContainerError? = nil
        ) {
            viewModel = .init(
                isSaving: isSaving ?? viewModel.isSaving,
                unit: unit ?? viewModel.unit,
                selectedDrink: selectedDrink ?? viewModel.selectedDrink,
                editedSize: editedSize ?? viewModel.editedSize,
                editedFill: editedFill ?? viewModel.editedFill,
                containerRange: Double(containerRanger.min)...Double(containerRanger.max),
                error: error
            )
        }
    }
}

private extension Screen.EditContainer.Presenter {
    func getSize(from fill: Double) -> Double {
        let metricSize = fill * Double(containerRanger.max)
        let unit = engine.unitService.getUnitSystem()
        let size = engine.unitService.convert(
            metricSize,
            from: unit == .metric ? .millilitres : .ounces,
            to: .millilitres
        )
        return size
    }
    
    func getFill(from size: Double) -> Double {
        let unit = engine.unitService.getUnitSystem()
        let size = engine.unitService.convert(
            size,
            from: unit == .metric ? .millilitres : .ounces,
            to: .millilitres
        )
        let fill = size / Double(containerRanger.max)
        return fill
    }
}

extension EditContainer.ViewModel.UnitSystem {
    init(from unit: UnitServiceInterface.UnitSystem) {
        switch unit {
        case .imperial:
            self = .imperial
        case .metric:
            self = .metric
        }
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

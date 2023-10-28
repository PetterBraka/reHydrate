//
//  EditContainer.swift
//
//
//  Created by Petter vang Brakalsvålet on 14/10/2023.
//

import Foundation

public enum EditContainer {
    public enum Update {
        case viewModel
    }
    
    public enum Action {
        case didAppear
        case didTapSave(Double)
        case didTapCancel
        case didChangeSize(size: Double)
        case didChangeFill(fill: Double)
    }
    
    public struct ViewModel {
        public let isLoading: Bool
        public let unit: UnitSystem
        public let selectedDrink: Drink
        public let editedSize: Double
        public let editedFill: Double
        public let containerRange: ClosedRange<Double>
        public let error: EditContainerError?
        
        public init(isLoading: Bool, unit: UnitSystem, selectedDrink: Drink, editedSize: Double, editedFill: Double, containerRange: ClosedRange<Double>, error: EditContainerError?) {
            self.isLoading = isLoading
            self.unit = unit
            self.selectedDrink = selectedDrink
            self.editedSize = editedSize
            self.editedFill = editedFill
            self.containerRange = containerRange
            self.error = error
        }
    }
}

extension EditContainer.ViewModel {
    public enum UnitSystem {
        case imperial
        case metric
    }
}

public extension EditContainer.ViewModel {
    struct Drink {
        public let container: Container
        public var size: Double
        
        public init(size: Double,
                    container: Container) {
            self.container = container
            self.size = size
        }
    }
    
    enum Container {
        case small
        case medium
        case large
    }
}

public extension EditContainer.ViewModel {
    enum EditContainerError {
        case failedSaving
    }
}

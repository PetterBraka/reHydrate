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
        case didTapSave
        case didTapCancel
        case didChangeSize(size: Double)
        case didChangeFill(fill: Double)
    }
    
    public struct ViewModel {
        public let isSaving: Bool
        public let selectedDrink: Drink
        public let editedSize: Double
        public let editedFill: Double
        public let error: EditContainerError?
        
        public init(isSaving: Bool, selectedDrink: Drink, editedSize: Double, editedFill: Double, error: EditContainerError?) {
            self.isSaving = isSaving
            self.selectedDrink = selectedDrink
            self.editedSize = editedSize
            self.editedFill = editedFill
            self.error = error
        }
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
    enum EditContainerError: Error {
        case failedSaving
    }
}

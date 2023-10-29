//
//  EditContainerScreenObservable.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 14/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import UserNotifications
import EditContainerPresentationInterface
import PresentationKit
import EngineKit


final class EditContainerScreenObservable: ObservableObject, EditContainerSceneType {
    private let presenter: EditContainerPresenterType
    
    var viewModel: EditContainer.ViewModel
    
    let formatter: NumberFormatter
    
    let range = 0.1 ... 0.9
    @Published var fill: Double
    @Published var size: Double
    
    init(presenter: EditContainerPresenterType) {
        self.presenter = presenter
        self.viewModel = presenter.viewModel
        fill = viewModel.editedFill
        size = viewModel.editedSize
        
        formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.allowsFloats = true
    }
    
    func perform(update: EditContainer.Update) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch update {
            case .viewModel:
                self.viewModel = presenter.viewModel
                self.fill = viewModel.editedFill
                self.size = viewModel.editedSize
            }
            self.objectWillChange.send()
        }
    }
    
    func perform(action: EditContainer.Action) {
        Task {
            await presenter.perform(action: action)
        }
    }
}

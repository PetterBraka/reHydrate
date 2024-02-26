//
//  PopUp.swift
//  
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

import PresentationInterface

public enum PopUp {
    case edit(Home.ViewModel.Drink)
    case credits
    case appIcon
}

extension PopUp: Identifiable {
    public var id: String {
        switch self {
        case let .edit(drink):
            "edit-" + String(describing: drink)
        case .credits:
            "credits"
        case .appIcon:
            "appIcon"
        }
    }
    
}

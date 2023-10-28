//
//  PopUp.swift
//  
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

import HomePresentationInterface

public enum PopUp {
    case edit(Home.ViewModel.Drink)
}

extension PopUp: Identifiable {
    public var id: String {
        switch self {
        case let .edit(drink):
            "edit-" + String(describing: drink)
        }
    }
    
}

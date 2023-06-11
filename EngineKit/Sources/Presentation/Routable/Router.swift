//
//  Router.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//

import HomePresentationInterface

public final class Router {
    public init() {}
}

extension Router: HomeRoutable {
    public func showSettings() {
        // TODO: Show Settings
        print("Show settings")
    }
    
    public func showHistory() {
        // TODO: Show History
        print("Show history")
    }
    
    public func showEdit(drink: Home.ViewModel.Drink) {
        // TODO: Show Edit
        print("Show edit - \(String(describing: drink))")
    }
}

//
//  Router.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//

import HomePresentationInterface

public final class Router {
    public weak var sceneObserver: RouterObservableType?
    
    public init() {}
}

extension Router: HomeRoutable {
    public func showSettings() {
        sceneObserver?.setTab(to: .settings)
    }
    
    public func showHistory() {
        sceneObserver?.setTab(to: .history)
    }
    
    public func showEdit(drink: Home.ViewModel.Drink) {
        // TODO: Show Edit
        print("Show edit - \(String(describing: drink))")
    }
}

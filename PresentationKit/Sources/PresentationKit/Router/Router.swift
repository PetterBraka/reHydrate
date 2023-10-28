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
    public func showHome() {
        sceneObserver?.setTab(to: .home)
    }
    
    public func showEdit(drink: Home.ViewModel.Drink) {
        sceneObserver?.setPopUp(to: .edit(drink))
    }
}

extension Router: SettingsRoutable {
    public func showSettings() {
        sceneObserver?.setTab(to: .settings)
    }
}

extension Router: HistoryRoutable {
    public func showHistory() {
        sceneObserver?.setTab(to: .history)
    }
}

extension Router: EditContainerRoutable {
    public func close() {
        sceneObserver?.setPopUp(to: .none)
    }
}

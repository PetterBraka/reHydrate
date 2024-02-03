//
//  Router.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//

import PresentationInterface

public final class Router {
    public weak var sceneObserver: RouterObservableType?
    
    public init() {}
    
    public func showHome() {
        sceneObserver?.setTab(to: .home)
    }
    
    public func showHistory() {
        sceneObserver?.setTab(to: .history)
    }
    
    public func showSettings() {
        sceneObserver?.setTab(to: .settings)
    }
    
    public func close() {
        sceneObserver?.setPopUp(to: .none)
    }
    
    public func showEdit(drink: Home.ViewModel.Drink) {
        sceneObserver?.setPopUp(to: .edit(drink))
    }
    
    public func showCredits() {
        sceneObserver?.setPopUp(to: .credits)
    }
    
    public func showAppIcon() {
        sceneObserver?.setPopUp(to: .appIcon)
    }
}

extension Router: HomeRoutable {}
extension Router: SettingsRoutable {}
extension Router: HistoryRoutable {}
extension Router: EditContainerRoutable {}
extension Router: CreditsRoutable {}
extension Router: AppIconRoutable {}

//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 23/03/2024.
//

import PresentationInterface

public final class RouterSpy {
    public var log: [MethodCall] = []
    
    public enum MethodCall: Equatable {
        case showHome
        case showHistory
        case showSettings
        case close
        case showEdit(_ drink: Home.ViewModel.Drink)
        case showCredits
        case showAppIcon
    }
}

extension RouterSpy {
    public func showHome() {
        log.append(.showHome)
    }
    
    public func showHistory() {
        log.append(.showHistory)
    }
    
    public func showSettings() {
        log.append(.showSettings)
    }
    
    public func close() {
        log.append(.close)
    }
    
    public func showEdit(drink: Home.ViewModel.Drink) {
        log.append(.showEdit(drink))
    }
    
    public func showCredits() {
        log.append(.showCredits)
    }
    
    public func showAppIcon() {
        log.append(.showAppIcon)
    }
}

extension RouterSpy:
    HomeRoutable,
    SettingsRoutable,
    HistoryRoutable,
    EditContainerRoutable,
    CreditsRoutable,
    AppIconRoutable {}

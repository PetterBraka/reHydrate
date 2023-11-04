//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 04/11/2023.
//

import AppearanceServiceInterface
import PortsInterface
import UserPreferenceServiceInterface
import LoggingService

public final class AppearanceService: AppearanceServiceType {
    public typealias Engine = (
        HasLoggingService &
        HasUserPreferenceService &
        HasPorts
    )
    private let engine: Engine
    
    let preferenceKey = "AppearanceService.key"
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func getAppearance() -> Appearance {
        let currentStyle = engine.appearancePort.getStyle()
        let storedAppearance: String? = engine.userPreferenceService.get(for: preferenceKey)
        return .init(rawValue: storedAppearance ?? "") ?? .init(from: currentStyle) ?? .light
    }
    
    public func setAppearance(_ appearance: AppearanceServiceInterface.Appearance) {
        do {
            try engine.userPreferenceService.set(preferenceKey, for: appearance.rawValue)
            try engine.appearancePort.setStyle(.init(from: appearance))
        } catch {
            engine.logger.error("Unable to set \(appearance.rawValue) appearance", error: error)
            let inverted: Appearance = appearance == .dark ? .light : .dark
            try? engine.userPreferenceService.set(preferenceKey, for: inverted.rawValue)
        }
    }
}

fileprivate extension PortsInterface.Style {
    init(from appearance: AppearanceServiceInterface.Appearance) {
        self = switch appearance {
        case .dark: .dark
        case .light: .light
        }
    }
}

fileprivate extension AppearanceServiceInterface.Appearance {
    init?(from style: PortsInterface.Style?) {
        guard let style else { return nil }
        self = switch style {
        case .dark: .dark
        case .light: .light
        }
    }
}

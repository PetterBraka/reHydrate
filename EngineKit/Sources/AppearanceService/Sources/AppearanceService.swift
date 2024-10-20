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
        HasLoggerService &
        HasUserPreferenceService &
        HasPorts
    )
    private let engine: Engine
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func getAppearance() -> Appearance {
        let currentStyle = engine.appearancePort.getStyle()
        let storedAppearance: String? = engine.userPreferenceService.get(for: .appearance)
        return .init(rawValue: storedAppearance ?? "") ?? .init(from: currentStyle) ?? .light
    }
    
    public func setAppearance(_ appearance: AppearanceServiceInterface.Appearance) {
        do {
            try engine.userPreferenceService.set(appearance.rawValue, for: .appearance)
            try engine.appearancePort.setStyle(.init(from: appearance))
        } catch {
            engine.logger.log(
                category: .userPreferences,
                message: "Unable to set \(appearance.rawValue) appearance",
                error: error,
                level: .error
            )
            let inverted: Appearance = appearance == .dark ? .light : .dark
            try? engine.userPreferenceService.set(inverted.rawValue, for: .appearance)
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

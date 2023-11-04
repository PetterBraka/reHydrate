//
//  AppearanceServicePort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 04/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import PortsInterface
import UIKit

final class AppearanceServicePort: AppearancePortType {
    func getStyle() -> Style? {
        let style = UITraitCollection.current.userInterfaceStyle
        return .init(from: style)
    }
    
    func setStyle(_ style: Style) throws {
        guard let window = UIApplication.shared.keyWindows.first else {
            throw AppearanceError.noActiveWindow
        }
        window.overrideUserInterfaceStyle = .init(from: style)
    }
}

extension UIUserInterfaceStyle {
    init(from style: Style) {
        self = switch style {
        case .dark: .dark
        case .light: .light
        }
    }
}

extension Style {
    init?(from style: UIUserInterfaceStyle) {
        switch style {
        case .light: 
            self = .light
        case .dark:
            self = .dark
        case .unspecified:
            return nil
        @unknown default:
            return nil
        }
    }
}

extension AppearanceServicePort {
    enum AppearanceError: Error {
        case noActiveWindow
    }
}

//
//  AlternateIconsServicePort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import PortsInterface

final class AlternateIconsServicePort: AlternateIconsServiceType {
    func supportsAlternateIcons() async -> Bool {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let isSupported = UIApplication.shared.supportsAlternateIcons
                continuation.resume(returning: isSupported)
            }
        }
    }
    
    func setAlternateIcon(to iconName: String) async -> Error? {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                UIApplication.shared.setAlternateIconName(iconName) { error in
                    continuation.resume(returning: error)
                }
            }
        }
    }
    
    func getAlternateIcon() async -> String? {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let iconName = UIApplication.shared.alternateIconName
                continuation.resume(returning: iconName)
            }
        }
    }
}

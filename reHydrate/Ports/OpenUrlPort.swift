//
//  OpenUrlPort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import PortsInterface

final class OpenUrlPort: OpenUrlServiceInterface {
    public private(set) var settingsUrl = URL(string: UIApplication.openSettingsURLString)
    
    @MainActor
    func open(url: URL) async {
        guard UIApplication.shared.canOpenURL(url) else { return }
        await UIApplication.shared.open(url)
    }
}

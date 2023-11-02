//
//  UIApplication+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

extension UIApplication {
    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1"
    }
}

//
//  IconHelper+Helper.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 07/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreInterfaceKit
import UIKit

public final class IconHelper: ObservableObject {
    public let iconNames: [Icon] = Icon.allCases

    @Published public var currentIndex: Int
    @Published public var currentItem: Icon

    public init() {
        if let currentIcon = UIApplication.shared.alternateIconName {
            currentItem = Icon(rawValue: currentIcon) ?? .blackWhite
            currentIndex = iconNames.firstIndex(of: Icon(rawValue: currentIcon) ?? .blackWhite) ?? 0
        } else {
            currentItem = .blackWhite
            currentIndex = 0
        }
    }
}

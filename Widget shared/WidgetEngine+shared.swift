//
//  WidgetEngine+shared.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetEngine

extension WidgetEngine {
    static let shared: WidgetEngine = WidgetEngine(
        appGroup: "group.com.braka.reHydrate.shared",
        subsystem: "com.braka.reHydrate.Widget"
    )
}

//
//  WidgetEngine.swift
//  WidgetExtension
//
//  Created by Petter vang Brakalsvålet on 15/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetEngine

extension WidgetEngine {
    static let shared: WidgetEngine = WidgetEngine(
        appGroup: "group.com.braka.reHydrate.shared",
        subsystem: "com.braka.reHydrate.Widget"
    )
}

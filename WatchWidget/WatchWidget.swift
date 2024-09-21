//
//  WatchWidget.swift
//  Widget
//
//  Created by Petter vang Brakalsvålet on 09/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetEngine
import WidgetKit
import SwiftUI

@main
struct WatchWidget: Widget {
    let engine: WidgetEngine = WidgetEngine(
        appGroup: "group.com.braka.reHydrate.shared",
        subsystem: "com.braka.reHydrate.Widget"
    )
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "basic", provider: BasicProvider(engine: engine)) { entry in
            BasicView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Todays consumption")
        .description("This helps you keep track of your water consumption today.")
    }
}

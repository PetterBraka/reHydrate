//
//  WatchWidget.swift
//  WatchWidget
//
//  Created by Petter vang Brakalsvålet on 21/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetEngine
import WidgetKit
import SwiftUI

@main
struct WatchWidget: Widget {
    let kind: String = "today-widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BasicProvider(engine: .shared)) { entry in
            BasicView(entry: entry)
        }
        .configurationDisplayName("My today")
        .description("This helps you keep track of your water consumption today.")
    }
}

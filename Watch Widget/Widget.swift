//
//  Watch_Widget.swift
//  Watch Widget
//
//  Created by Petter vang Brakalsvålet on 09/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct Watch_Widget: Widget {
    let kind: String = "Watch_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Watch_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.accessoryCorner, .accessoryCorner, .accessoryInline, .accessoryRectangular])
        .configurationDisplayName("My consumption")
        .description("This helps you keep track of your water consumption.")
    }
}

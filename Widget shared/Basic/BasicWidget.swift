//
//  Basic.swift
//  Widget
//
//  Created by Petter vang Brakalsvålet on 09/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetEngine
import WidgetKit
import SwiftUI

struct BasicWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "basic", provider: BasicProvider()) { entry in
            BasicView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName(
            LocalizedString(
                "ui.widget.basic.name",
                value: "Todays consumption",
                comment: "Widget name for a basic widget to track todays consumption."
            )
        )
        .description(
            LocalizedString(
                "ui.widget.basic.description",
                value: "A widget to track todays consumption.",
                comment: "Widget description for a basic widget to track todays consumption."
            )
        )
        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    BasicWidget()
} timeline: {
    BasicEntry(date: .now, consumed: 0, goal: 2, symbol: "L")
}

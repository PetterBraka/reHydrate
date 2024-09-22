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
        .configurationDisplayName("Todays consumption")
        .description("This helps you keep track of your water consumption today.")
        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    BasicWidget()
} timeline: {
    BasicEntry(date: .now, consumed: 0, goal: 2, symbol: "L")
}

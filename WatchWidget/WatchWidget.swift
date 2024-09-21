//
//  WatchWidget.swift
//  WatchWidget
//
//  Created by Petter vang Brakalsvålet on 21/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import PresentationWidgetKitInterface
import PresentationWidgetKit
import WidgetEngine
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.com.braka.reHydrate.shared")
    
    func placeholder(in context: Context) -> BasicEntry {
        BasicEntry(date: .now, consumed: 0, goal: 2, symbol: "L")
    }

    func getSnapshot(in context: Context, completion: @escaping (BasicEntry) -> ()) {
        let entry = BasicEntry(date: .now, consumed: 0, goal: 2, symbol: "L")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = BasicEntry(date: .now, consumed: 0, goal: 2, symbol: "L")
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

@main
struct WatchWidget: Widget {
    let kind: String = "today-widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BasicView(entry: entry)
        }
        .configurationDisplayName("My today")
        .description("This helps you keep track of your water consumption today.")
    }
}

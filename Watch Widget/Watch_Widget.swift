//
//  Watch_Widget.swift
//  Watch Widget
//
//  Created by Petter vang Brakalsvålet on 09/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct Watch_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                Text("Time:")
                Text(entry.date, style: .time)
            }

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

@main
struct Watch_Widget: Widget {
    let kind: String = "Watch_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                Watch_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Watch_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .accessoryRectangular) {
    Watch_Widget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

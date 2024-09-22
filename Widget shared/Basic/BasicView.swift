//
//  BasicView.swift
//  Watch WidgetExtension
//
//  Created by Petter vang Brakalsvålet on 15/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetKit
import SwiftUI

struct BasicView : View {
    @Environment(\.widgetFamily) private var family
    
    var entry: BasicEntry
    
    var body: some View {
        Group {
            switch family {
            case .accessoryCircular, .systemSmall:
                circularGauge
            case .accessoryCorner:
                cornerGauge
            case .accessoryRectangular:
                VStack(alignment: .leading) {
                    motivationalText
                    linearGauge
                }
            default:
                Label {
                    summaryText
                } icon: {
                    waterDrop
                }
            }
        }
        .tint(.cyan)
        .privacySensitive(false)
    }
    
    private var circularGauge: some View {
        Gauge(value: entry.consumed, in: 0 ... entry.goal) {
            EmptyView()
        } currentValueLabel: {
            consumedText
        }
        .gaugeStyle(.accessoryCircularCapacity)
    }
    
    private var cornerGauge: some View {
        Text(entry.consumed, format: .number)
            .widgetCurvesContent()
            .widgetLabel {
                circularGauge
                    .gaugeStyle(.accessoryLinearCapacity)
            }
    }
    
    @ViewBuilder
    private var motivationalText: some View {
        let difference = entry.goal - entry.consumed
        if difference > 1 {
            Text(String(format: "You still need %.1f%@", difference, entry.symbol))
        } else if difference > 0 {
            Text(String(format: "Only %.1f%@ left", difference, entry.symbol))
        } else{
            Text("You did it!")
        }
    }
    
    private var linearGauge: some View {
        Gauge(value: entry.consumed, in: 0 ... entry.goal) {
            EmptyView()
        } currentValueLabel: {
            EmptyView()
        } minimumValueLabel: {
            Text(0.0, format: .number)
        } maximumValueLabel: {
            goalText
        }
        .gaugeStyle(.accessoryLinearCapacity)
    }
    
    private var consumedText: Text {
        Text(entry.consumed, format: .number)
    }
    
    private var goalText: Text {
        Text(entry.goal, format: .number)
    }
    
    private var summaryText: some View {
        Text(String(format: "%.1f/%.1f %@", entry.consumed, entry.goal, entry.symbol))
    }
    
    private var waterDrop: Image {
        if (entry.consumed / entry.goal) > 0.9 {
            Image(systemName: "drop.fill")
        } else if (entry.consumed / entry.goal) > 0.3 {
            Image(systemName: "drop.halffull")
        } else {
            Image(systemName: "drop")
        }
    }
}

#Preview(as: .accessoryRectangular) {
    BasicWidget()
} timeline: {
    BasicEntry(date: .now, consumed: 1, goal: 2.5, symbol: "L")
}

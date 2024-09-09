//
//  Entry.swift
//  Watch WidgetExtension
//
//  Created by Petter vang Brakalsvålet on 09/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let consumed: Double
    let goal: Double
    let symbol: String
}

struct Watch_WidgetEntryView : View {
    @Environment(\.widgetFamily) private var family
    
    var entry: Provider.Entry
    
    var body: some View {
        Group {
            switch family {
            case .accessoryCircular:
                accessoryCircular
            case .accessoryCorner:
                accessoryCorner
            case .accessoryRectangular:
                accessoryRectangular
            case .accessoryInline:
                accessoryInline
            case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
                unsupported
            @unknown default:
                unsupported
            }
        }
        .tint(.cyan)
    }
    
    private var accessoryCircular: some View {
        Gauge(value: entry.consumed, in: 0 ... entry.goal) {
            EmptyView()
        } currentValueLabel: {
            Text(entry.consumed, format: .number)
        }
        .gaugeStyle(.accessoryCircularCapacity)
    }
    
    private var accessoryCorner: some View {
        Text(entry.consumed, format: .number)
            .widgetCurvesContent()
            .widgetLabel {
                Gauge(value: entry.consumed, in: 0 ... entry.goal) {
                    EmptyView()
                } currentValueLabel: {
                    Text(entry.consumed, format: .number)
                }
                .gaugeStyle(.accessoryLinearCapacity)
            }
    }
    
    private var accessoryRectangular: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.consumed, format: .number) + Text("/") + Text(entry.goal, format: .number) + Text(entry.symbol)
            Gauge(value: entry.consumed, in: 0 ... entry.goal) {
                EmptyView()
            } currentValueLabel: {
                EmptyView()
            } minimumValueLabel: {
                Text(0.0, format: .number)
            } maximumValueLabel: {
                Text(entry.goal, format: .number)
            }
            .gaugeStyle(.accessoryLinearCapacity)
        }
    }
    
    private var accessoryInline: some View {
        Gauge(value: entry.consumed, in: 0 ... entry.goal) {
            EmptyView()
        } currentValueLabel: {
            Text(entry.consumed, format: .number)
        }
        .gaugeStyle(.accessoryLinearCapacity)
    }
    
    private var unsupported: some View {
        Text(entry.consumed, format: .number) +
        Text("/") +
        Text(entry.goal, format: .number) +
        Text(entry.symbol)
    }
}

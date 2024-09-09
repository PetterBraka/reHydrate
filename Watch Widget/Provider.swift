//
//  Provider.swift
//  Watch AppUITests
//
//  Created by Petter vang Brakalsvålet on 09/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, consumed: 1.3, goal: 3, symbol: "L")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: .now, consumed: 1.3, goal: 3, symbol: "L")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: .now, consumed: 1.2, goal: 3, symbol: "L")
        
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

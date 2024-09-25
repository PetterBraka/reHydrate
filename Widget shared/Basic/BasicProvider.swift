//
//  BasicProvider.swift
//  Watch
//
//  Created by Petter vang Brakalsvålet on 09/09/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import PresentationWidgetKitInterface
import PresentationWidgetKit
import WidgetEngine
import WidgetKit
import SwiftUI

struct BasicProvider: TimelineProvider {
    let presenter: TodayPresenter
    
    init() {
        self.presenter = Screen.Today.Presenter(appGroup: "group.com.braka.reHydrate.shared")
    }
    
    func placeholder(in context: Context) -> BasicEntry {
        BasicEntry(date: .now, consumed: 0, goal: 0, symbol: "L")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BasicEntry) -> ()) {
        let viewModel = presenter.getViewModel()
        let entry = BasicEntry(
            date: viewModel.date,
            consumed: viewModel.consumed,
            goal: viewModel.goal,
            symbol: viewModel.symbol
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BasicEntry>) -> ()) {
        let viewModel = presenter.getViewModel()
        let entry = BasicEntry(
            date: viewModel.date,
            consumed: viewModel.consumed,
            goal: viewModel.goal,
            symbol: viewModel.symbol
        )
        let lastEntry = BasicEntry(
            date: viewModel.endOfDay,
            consumed: 0,
            goal: viewModel.goal,
            symbol: viewModel.symbol
        )
        
        let timeline = Timeline(entries: [entry, lastEntry], policy: .never)
        
        completion(timeline)
    }
}

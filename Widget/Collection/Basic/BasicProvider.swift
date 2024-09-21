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
    
    init(engine: WidgetEngine) {
        self.presenter = Screen.Today.Presenter(engine: engine)
    }
    
    func placeholder(in context: Context) -> BasicEntry {
        BasicEntry(date: .now, consumed: 0, goal: 0, symbol: "L")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BasicEntry) -> ()) {
        if context.isPreview {
            completion(BasicEntry(date: .now, consumed: 1.4, goal: 2, symbol: "L"))
        } else {
            Task {
                let viewModel = await presenter.getViewModel()
                let entry = BasicEntry(from: viewModel)
                completion(entry)
            }
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BasicEntry>) -> ()) {
        Task {
            let viewModel = await presenter.getViewModel()
            let endOfDayViewModel = await presenter.getEndOfDayViewModel()
            let entry = BasicEntry(from: viewModel)
            let lastEntry = BasicEntry(from: endOfDayViewModel)
            
            let timeline = Timeline(entries: [entry, lastEntry], policy: .never)
            
            completion(timeline)
        }
    }
}

extension BasicEntry {
    init(from viewModel: Today.ViewModel) {
        date = viewModel.date
        consumed = viewModel.consumed
        goal = viewModel.goal
        symbol = viewModel.symbol
    }
}

//
//  HistoryScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import Charts
import HistoryPresentationInterface
import PresentationKit
import EngineKit
import CalendarKit

struct HistoryScreen: View {
    @ObservedObject var observer: HistoryScreenObservable
    @State var contentHeight: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            toolbar
            content
                .getHeight($contentHeight)
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
        }
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .onAppear {
            observer.perform(action: .didAppear)
        }
        .font(.brandBody)
    }
    
    @ViewBuilder
    var toolbar: some View {
        CustomToolbar {
            Text(historyTitle)
                .foregroundStyle(Color.label)
        } leadingButton: {
            Button {
                observer.perform(action: .didTapBack)
            } label: {
                HStack {
                    Image.back
                    Text("Back")
                }
            }
            .foregroundColor(.button)
            .padding(.leading, 24)
        }
    }
    
    @ViewBuilder
    var content: some View {
        VStack(alignment: .center, spacing: 8) {
            chart
                .border(.red)
                .frame(height: contentHeight / 3)
            Spacer()
            calendar
        }
    }
    
    @ViewBuilder
    var chart: some View {
        VStack(spacing: 0) {
            Text(observer.viewModel.startDate + " - " + observer.viewModel.endDate)
            Chart(observer.viewModel.data, id: \.date) { day in
                let xPoint: PlottableValue = .value(chartDatePoint, day.date)
                if let goal = day.goal {
                    LineMark(x: xPoint, y: .value(chartGoalPoint, goal))
                        .foregroundStyle(.green.opacity(0.5))
                }
                let consumed = day.consumed ?? 0
                switch observer.viewModel.chart {
                case .bar:
                    BarMark(x: xPoint,
                            y: .value(chartConsumedPoint, consumed))
                case .line:
                    LineMark(x: xPoint,
                             y: .value(chartConsumedPoint, consumed))
                case .plot:
                    PointMark(x: xPoint,
                              y: .value(chartConsumedPoint, consumed))
                }
            }
        }
    }
    
    @ViewBuilder
    var calendar: some View {
        let dateBinding = Binding {
            observer.viewModel.highlightedMonth
        } set: { date in
            observer.perform(action: .didChangeHighlightedMonthTo(date))
        }
        CalendarView(
            selectedDate: dateBinding,
            range: observer.viewModel.dateRange,
            startOfWeek: .init(from: observer.viewModel.weekdayStart)) { day in
                observer.perform(action: .didTap(day.date))
            }
    }
}

// MARK: - Strings
extension HistoryScreen {
    var historyTitle: String {
        LocalizedString("ui.history.title", 
                        value: "History",
                        comment: "The title of the history screen.")
    }
    
    var backButtonTitle: String {
        LocalizedString("ui.history.back", 
                        value: "Back",
                        comment: "The back button in the history screen")
    }
    
    var chartDatePoint: String {
        LocalizedString("ui.history.chart.date", 
                        value: "Date",
                        comment: "")
    }
    
    var chartGoalPoint: String {
        LocalizedString("ui.history.chart.goal", 
                        value: "Goal",
                        comment: "")
    }
    
    var chartConsumedPoint: String {
        LocalizedString("ui.history.chart.consumed", 
                        value: "Consumed",
                        comment: "")
    }
}

#Preview {
    SceneFactory.shared.makeHistoryScreen()
}

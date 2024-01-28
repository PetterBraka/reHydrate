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
        VStack(alignment: .leading, spacing: 16) {
            toolbar
            content
                .getHeight($contentHeight)
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
            Text(Localized.historyTitle)
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
            details
//            chart
//                .frame(height: contentHeight / 3)
            Spacer()
            calendar
        }
        .animation(.default, value: observer.viewModel.selectedRange)
    }
    
//    @ViewBuilder
//    var chart: some View {
//        VStack(spacing: 8) {
//            Text(observer.viewModel.chart.title)
//            Chart(observer.viewModel.chart.data, id: \.date) { day in
//                let xPoint: PlottableValue = .value(Localized.chartDatePoint, day.dateString)
//                if let goal = day.goal {
//                    LineMark(x: xPoint, y: .value(Localized.chartGoalPoint, goal))
//                        .foregroundStyle(.green.opacity(0.5))
//                        .foregroundStyle(by: .value(Localized.chartGoalPoint, Localized.chartGoalPoint))
//                }
//                let consumed = day.consumed ?? 0
//                switch observer.viewModel.chart.selectedOption {
//                case .bar:
//                    BarMark(x: xPoint, y: .value(Localized.chartConsumedPoint, consumed))
//                        .foregroundStyle(by: .value(Localized.chartConsumedPoint, Localized.chartConsumedPoint))
//                case .line:
//                    LineMark(x: xPoint, y: .value(Localized.chartConsumedPoint, consumed))
//                        .foregroundStyle(by: .value(Localized.chartConsumedPoint, Localized.chartConsumedPoint))
//                case .plot:
//                    PointMark(x: xPoint, y: .value(Localized.chartConsumedPoint, consumed))
//                        .foregroundStyle(by: .value(Localized.chartConsumedPoint, Localized.chartConsumedPoint))
//                }
//            }
//        }
//    }
    
    @ViewBuilder
    var details: some View {
        let details = observer.viewModel.details
        VStack(alignment: .leading, spacing: 8) {
            row(Localized.detailsAverageGoal, value: details.averageGoal)
            row(Localized.detailsAverageConsumed, value: details.averageConsumed)
            Divider()
            row(Localized.detailsTotalGoal, value: details.totalGoal)
            row(Localized.detailsTotalConsumed, value: details.totalConsumed)
            Divider()
        }
    }
    
    @ViewBuilder
    func row(_ label: String, value: String) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Text(label)
            Spacer()
            Text(value)
        }
    }
    
    @ViewBuilder
    var calendar: some View {
        VStack(spacing: 16) {
            Spacer()
            HStack {
                Spacer()
                Button("Clear selection") {
                    observer.perform(action: .didTapClear)
                }
            }
            let dateBinding = Binding {
                observer.viewModel.calendar.highlightedMonth
            } set: { date in
                observer.perform(action: .didChangeHighlightedMonthTo(date))
            }
            CalendarView(
                selectedDate: dateBinding,
                range: observer.viewModel.calendar.range,
                startOfWeek: .init(from: observer.viewModel.calendar.weekdayStart)
            ) { day in
                observer.perform(action: .didTap(day.date))
            } customDayView: { day in
                Text("\(day.day)")
                    .expandVH()
                    .font(.caption)
                    .background {
                        getImageForSelected(day.date)
                    }
            }
            .frame(maxHeight: contentHeight / 2)
        }
    }
    
    @ViewBuilder
    func getImageForSelected(_ date: Date) -> some View {
        if let range = observer.viewModel.selectedRange {
            Group {
                if observer.viewModel.selectedDays == 1,
                   range.lowerBound.inSameDayAs(date) ||
                    range.contains(date) {
                    Image.circle
                        .resizable()
                } else if range.lowerBound.inSameDayAs(date) {
                    Image.leftSelected
                        .resizable()
                } else if range.upperBound.inSameDayAs(date) {
                    Image.rightSelected
                        .resizable()
                } else if range.contains(date) {
                    Image.midSelected
                        .resizable()
                }
            }
            .aspectRatio(contentMode: .fill)
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Strings
extension HistoryScreen {
    enum Localized {
        static let historyTitle = LocalizedString(
            "ui.history.title", value: "History",
            comment: "The title of the history screen."
        )
        
        static let backButtonTitle = LocalizedString(
            "ui.history.back", value: "Back",
            comment: "The back button in the history screen"
        )
        
        static let detailsAverageGoal = LocalizedString(
            "ui.history.details.average.goal", value: "Goal avg",
            comment: "A label displayed next to the average goal for a given range"
        )
        
        static let detailsAverageConsumed = LocalizedString(
            "ui.history.details.average.consumed", value: "Consumed avg",
            comment: "A label displayed next to the average consumption for a given range"
        )
        
        static let detailsTotalGoal = LocalizedString(
            "ui.history.details.total.goal", value: "Goal",
            comment: "A label displayed next to the total goal for a given range"
        )
        
        static let detailsTotalConsumed = LocalizedString(
            "ui.history.details.total.consumed", value: "Consumed",
            comment: "A label displayed next to the total consumed for a given range"
        )
        
//        static let chartDatePoint = LocalizedString("ui.history.chart.date", value: "Date", comment: "")
//
//        static let chartGoalPoint = LocalizedString("ui.history.chart.goal", value: "Goal", comment: "")
//
//        static let chartConsumedPoint = LocalizedString("ui.history.chart.consumed", value: "Consumed", comment: "")
    }
}

#Preview {
    SceneFactory.shared.makeHistoryScreen()
}

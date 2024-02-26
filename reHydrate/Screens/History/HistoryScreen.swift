//
//  HistoryScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import Charts
import PresentationInterface
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
                .font(.Theme.body)
        }
//        .background(Color.background, ignoresSafeAreaEdges: .all)
        .onAppear {
            observer.perform(action: .didAppear)
        }
        .font(.Theme.body)
    }
    
    @ViewBuilder
    var toolbar: some View {
        CustomToolbar {
            Text(Localized.historyTitle)
//                .foregroundStyle(.primary)
        } leadingButton: {
            Button {
                observer.perform(action: .didTapBack)
            } label: {
                HStack {
                    Image.back
                    Text("Back")
                }
            }
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
            } set: { _ in }
            CalendarView(
                selectedDate: dateBinding,
                range: observer.viewModel.calendar.range,
                startOfWeek: .init(from: observer.viewModel.calendar.weekdayStart)
            ) { day in
                observer.perform(action: .didTap(day.date))
            } customDayView: { day in
                VStack(alignment: .center, spacing: 0) {
                    Text("\(day.day)")
                        .font(.Theme.caption)
                    getIndicatorImage(for: day.date)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    ZStack {
                        if day.isToday {
                            Image.circle
                                .resizable()
                        }
                        getSelectionIndicator(for: day.date)
                    }
                }
                .border(.black, width: 0.25)
                .contentShape(Rectangle())
                .onTapGesture {
                    observer.perform(action: .didTap(day.date))
                }
            } customWeekdayLabel: { weekday in
                Text(weekday)
                    .font(.Theme.caption)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background {
                        Color.accentColor.opacity(0.2)
                    }
                    .border(.black, width: 0.25)
            }
            .frame(maxHeight: contentHeight / 2)
        }
    }
    
    @ViewBuilder
    func getSelectionIndicator(for date: Date) -> some View {
        if let range = observer.viewModel.selectedRange {
            if range.lowerBound.inSameDayAs(date) {
                Image.leftSelected
                    .resizable(resizingMode: .stretch)
            } else if range.upperBound.inSameDayAs(date) {
                Image.rightSelected
                    .resizable(resizingMode: .stretch)
            } else if range.contains(date) {
                Image.midSelected
                    .resizable(resizingMode: .stretch)
            }
        }
    }
    
    @ViewBuilder
    func getIndicatorImage(for date: Date) -> some View {
        let days = observer.viewModel.calendar.days
        if let day = days.first(where: { $0.date.inSameDayAs(date) }) {
            let goal = day.goal
            let consumed = day.consumed
            let fill = consumed / goal
            switch fill {
            case 0.9 ..< 1 :
                Image.waterDrop100
                    .resizable()
            case 0.6 ... 0.9:
                Image.waterDrop75
                    .resizable()
            case 0.3 ... 0.6:
                Image.waterDrop50
                    .resizable()
            case 0.1 ... 0.3:
                Image.waterDrop25
                    .resizable()
            default:
                Image.waterDrop0
                    .resizable()
            }
        } else {
            Color.clear
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

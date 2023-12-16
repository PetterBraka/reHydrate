//
//  MonthView.swift
//
//
//  Created by Petter vang Brakalsvålet on 16/12/2023.
//

import SwiftUI

struct MonthView<TodayView: View,
                 WeekdayLabelsBackground: View,
                 WeekendBackground: View>: View {
    let weekdays: [String]
    let dates: [ViewModel.CalendarDate]
    
    let labelFont: Font
    let dayFont: Font
    
    let todayView: (() -> TodayView)?
    let weekdayLabelsBackground: (() -> WeekdayLabelsBackground)?
    let weekendBackground: (() -> WeekendBackground)?
    
    let onTap: (ViewModel.CalendarDate) -> Void
    
    public var body: some View {
        Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
            weekdayLabels
                .font(labelFont)
            monthCells
                .font(dayFont)
        }
    }
    
    @ViewBuilder
    var weekdayLabels: some View {
        GridRow {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background {
            if let weekdayLabelsBackground {
                weekdayLabelsBackground()
            } else {
                Color.accentColor.opacity(0.75)
            }
        }
    }
    
    @ViewBuilder
    var monthCells: some View {
        ForEach(dates.chunked(into: 7), id: \.self) { week in
            GridRow {
                ForEach(week, id: \.date) { date in
                    DayView(date: date,
                            todayView: todayView,
                            weekendBackground: weekendBackground) {
                        onTap(date)
                    }
                }
            }
        }
    }
}

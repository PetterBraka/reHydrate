//
//  CalendarView+init.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/12/2023.
//

import SwiftUI

extension CalendarView where TodayView == EmptyView,
                             WeekdayLabelsBackground == EmptyView,
                             WeekendBackground == EmptyView {
    public init(
        month: Int = Calendar.current.component(.month, from: .now),
        year: Int = Calendar.current.component(.year, from: .now),
        startOfWeek: Weekday
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            todayView: nil,
            weekdayLabelsBackground: nil,
            weekendBackground: nil
        )
    }
}

extension CalendarView where TodayView == EmptyView,
                             WeekendBackground == EmptyView {
    public init(
        month: Int = Calendar.current.component(.month, from: .now),
        year: Int = Calendar.current.component(.year, from: .now),
        startOfWeek: Weekday,
        weekdayLabelsBackground: @escaping () -> WeekdayLabelsBackground
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            todayView: nil,
            weekdayLabelsBackground: weekdayLabelsBackground,
            weekendBackground: nil
        )
    }
}

extension CalendarView where TodayView == EmptyView,
                             WeekdayLabelsBackground == EmptyView {
    public init(
        month: Int = Calendar.current.component(.month, from: .now),
        year: Int = Calendar.current.component(.year, from: .now),
        startOfWeek: Weekday,
        weekendBackground: @escaping () -> WeekendBackground
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            todayView: nil,
            weekdayLabelsBackground: nil,
            weekendBackground: weekendBackground
        )
    }
}

extension CalendarView where WeekdayLabelsBackground == EmptyView,
                             WeekendBackground == EmptyView {
    public init(
        month: Int = Calendar.current.component(.month, from: .now),
        year: Int = Calendar.current.component(.year, from: .now),
        startOfWeek: Weekday,
        todayView: @escaping () -> TodayView
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            todayView: todayView,
            weekdayLabelsBackground: nil,
            weekendBackground: nil
        )
    }
}

extension CalendarView where WeekendBackground == EmptyView {
    public init(
        month: Int = Calendar.current.component(.month, from: .now),
        year: Int = Calendar.current.component(.year, from: .now),
        startOfWeek: Weekday,
        todayView: @escaping () -> TodayView,
        weekdayLabelsBackground: @escaping () -> WeekdayLabelsBackground
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            todayView: todayView,
            weekdayLabelsBackground: weekdayLabelsBackground,
            weekendBackground: nil
        )
    }
}
extension CalendarView where WeekendBackground == EmptyView {
    public init(
        month: Int = Calendar.current.component(.month, from: .now),
        year: Int = Calendar.current.component(.year, from: .now),
        startOfWeek: Weekday,
        weekdayLabelsBackground: @escaping () -> WeekdayLabelsBackground
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            todayView: nil,
            weekdayLabelsBackground: weekdayLabelsBackground,
            weekendBackground: nil
        )
    }
}

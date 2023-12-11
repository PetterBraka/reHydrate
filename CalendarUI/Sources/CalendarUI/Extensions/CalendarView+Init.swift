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
        startOfWeek: Weekday,
        titleFont: Font,
        labelFont: Font,
        dayFont: Font
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            titleFont: titleFont,
            labelFont: labelFont,
            dayFont: dayFont,
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
        titleFont: Font,
        labelFont: Font,
        dayFont: Font,
        weekdayLabelsBackground: @escaping () -> WeekdayLabelsBackground
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            titleFont: titleFont,
            labelFont: labelFont,
            dayFont: dayFont,
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
        titleFont: Font,
        labelFont: Font,
        dayFont: Font,
        weekendBackground: @escaping () -> WeekendBackground
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            titleFont: titleFont,
            labelFont: labelFont,
            dayFont: dayFont,
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
        titleFont: Font,
        labelFont: Font,
        dayFont: Font,
        todayView: @escaping () -> TodayView
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            titleFont: titleFont,
            labelFont: labelFont,
            dayFont: dayFont,
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
        titleFont: Font,
        labelFont: Font,
        dayFont: Font,
        todayView: @escaping () -> TodayView,
        weekdayLabelsBackground: @escaping () -> WeekdayLabelsBackground
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            titleFont: titleFont,
            labelFont: labelFont,
            dayFont: dayFont,
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
        titleFont: Font,
        labelFont: Font,
        dayFont: Font,
        weekdayLabelsBackground: @escaping () -> WeekdayLabelsBackground
    ) {
        self.init(
            month: month,
            year: year,
            startOfWeek: startOfWeek,
            titleFont: titleFont,
            labelFont: labelFont,
            dayFont: dayFont,
            todayView: nil,
            weekdayLabelsBackground: weekdayLabelsBackground,
            weekendBackground: nil
        )
    }
}

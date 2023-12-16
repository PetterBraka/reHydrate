//
//  DayView.swift
//
//
//  Created by Petter vang Brakalsvålet on 16/12/2023.
//

import SwiftUI

struct DayView<TodayView: View,
               WeekendBackground: View>: View {
    let date: ViewModel.CalendarDate
    let todayView: (() -> TodayView)?
    let weekendBackground: (() -> WeekendBackground)?
    
    let onTap: () -> Void
    
    var body: some View {
        let day = Calendar.current.component(.day, from: date.date)
        Text("\(day)")
            .opacity(date.isThisMonth ? 1.0 : 0.5)
            .aspectRatio(1, contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                ZStack {
                    if !date.isWeekday {
                        if let weekendBackground {
                            weekendBackground()
                        } else {
                            Color.accentColor
                                .opacity(0.25)
                        }
                    } else {
                        Color.white
                    }
                    
                    if date.isToday {
                        if let todayView {
                            todayView()
                        } else {
                            Circle()
                                .fill(.red)
                                .opacity(0.2)
                        }
                    }
                }
            }
            .onTapGesture {
                onTap()
            }
    }
}

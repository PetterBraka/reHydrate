//
//  CalendarView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import FSCalendar

struct CalendarView: View {
    @State var selectedDate: [Day] = []
    var navigateTo: (AppState) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button {
                    navigateTo(.home)
                } label: {
                    Image.exit
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.label)
                }
                .frame(width: 44)
                Spacer()
                Text("Monday 15/11/21")
                    .foregroundColor(.label)
                Spacer()
            }
            HStack {
                Text("Consumed:")
                Spacer()
                Text("1/3L")
            }
            HStack {
                Text("Average:")
                Spacer()
                Text("1.5L")
            }
            Spacer()
            
            CalendarModuleView(selectedDates: $selectedDate, firsWeekday: .monday)
        }
        .padding(.horizontal, 24)
        .background(Color.background.ignoresSafeArea())
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView() {_ in }
    }
}

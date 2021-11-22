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
    @StateObject var viewModel: CalendarViewModel
    
    init(navigateTo: @escaping ((AppState) -> Void)) {
        let viewModel = MainAssembler.shared.container.resolve(CalendarViewModel.self,
                                                               argument: navigateTo)!
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 16) {
                HStack {
                    Button {
                        viewModel.navigateToHome()
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
                
                CalendarModuleView(selectedDates: $viewModel.selectedDays,
                                   storedDays: $viewModel.days,
                                   firsWeekday: .monday)
                    .frame(height: geo.size.height / 2)
            }
            .padding(.horizontal, 24)
            .background(Color.background.ignoresSafeArea())
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView() {_ in }
    }
}

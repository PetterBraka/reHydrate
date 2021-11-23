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
            VStack {
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
                        .frame(width: 32)
                        
                        Spacer()
                        Text("Monday 15/11/21")
                            .font(.largeTitle)
                            .foregroundColor(.label)
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    
                    HStack {
                        Text("Consumed:")
                            .font(.title)
                            .foregroundColor(.label)
                        Spacer()
                        Text(viewModel.consumtion)
                            .font(.title)
                            .foregroundColor(.label)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Average:")
                            .font(.title)
                            .foregroundColor(.label)
                        Spacer()
                        Text(viewModel.average)
                            .font(.title)
                            .foregroundColor(.label)
                    }
                    
                    Divider()
                }
                
                Spacer()
                
                
                CalendarModuleView(selectedDays: $viewModel.selectedDays,
                                   storedDays: $viewModel.storedDays,
                                   firsWeekday: .monday)
                    .frame(height: geo.size.height * 0.5)
            }
            .onAppear {
                viewModel.fetchSavedDays()
            }
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

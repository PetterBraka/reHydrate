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
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                GeometryReader { geo in
                    VStack {
                        VStack(spacing: 16) {
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
                            .frame(height: geo.size.height * 0.6)
                    }
                    .onAppear {
                        viewModel.fetchSavedDays()
                    }
                }
                .padding(.horizontal, 16)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.header)
                        .font(.largeTitle)
                        .foregroundColor(.label)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.navigateToHome()
                    } label: {
                        Image.back
                            .font(.largeTitle)
                            .foregroundColor(.button)
                    }
                }
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView() {_ in }
    }
}

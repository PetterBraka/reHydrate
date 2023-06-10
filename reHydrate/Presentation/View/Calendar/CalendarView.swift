//
//  CalendarView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import FSCalendar
import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel: CalendarViewModel

    init(navigateTo: @escaping ((AppState) -> Void)) {
        let viewModel = MainAssembler.shared.container.resolve(CalendarViewModel.self,
                                                               argument: navigateTo)!
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            GeometryReader { geo in
                VStack {
                    HStack {
                        Button {
                            viewModel.navigateToHome()
                        } label: {
                            Image.back
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.button)
                        }
                        Spacer()
                        Text(viewModel.header)
                            .font(.brandTitle2)
                            .foregroundColor(.label)
                        Spacer()
                        Color.clear
                            .frame(width: 32, height: 32)
                    }
                    .padding(16)
                    VStack(spacing: 16) {
                        HStack {
                            Text(LocalizedStringKey(Localizable.consumed))
                                .font(.brandTitle)
                                .foregroundColor(.label)
                            Spacer()
                            Text(viewModel.consumtion)
                                .font(.brandTitle)
                                .foregroundColor(.label)
                        }
                        Divider()
                        HStack {
                            Text(LocalizedStringKey(Localizable.average))
                                .font(.brandTitle)
                                .foregroundColor(.label)
                            Spacer()
                            Text(viewModel.average)
                                .font(.brandTitle)
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
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView { _ in }
    }
}

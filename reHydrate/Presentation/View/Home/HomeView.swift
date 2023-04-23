//
//  HomeView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    init(navigateTo: @escaping ((AppState) -> Void)) {
        let viewModel = MainAssembler.shared.container.resolve(HomeViewModel.self,
                                                               argument: navigateTo)!
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("reHydrate")
                .font(.brandLargeHeader)
                .bold()
            Text(viewModel.getDate())
                .font(.brandTitle)
            let consumedGoal = viewModel.today.toLocal()
            Text("\(consumedGoal.consumption))/\(consumedGoal.goal)")
                .font(.brandExtraLargeTitle)
                .bold()

            Spacer()

            GeometryReader { geo in
                HStack(alignment: .bottom) {
                    DrinkView(viewModel: viewModel,
                              drink: $viewModel.drinks[0],
                              disable: false) {
                        viewModel.addDrink(viewModel.drinks[0])
                    }
                    .contextMenu {
                        Button(Localizable.editDrink.local(viewModel.language)) {
                            NotificationCenter.default.post(name: .editDrink, object: viewModel.drinks[0])
                        }
                        Button("Remove \(viewModel.drinks[0].toLocal())",
                               role: .destructive) {
                            viewModel.removeDrink(viewModel.drinks[0])
                        }
                    }
                    .frame(width: geo.size.width / 3,
                           height: 100,
                           alignment: .bottom)
                    DrinkView(viewModel: viewModel,
                              drink: $viewModel.drinks[1],
                              disable: false) {
                        viewModel.addDrink(viewModel.drinks[1])
                    }
                    .contextMenu {
                        Button(Localizable.editDrink.local(viewModel.language)) {
                            NotificationCenter.default.post(name: .editDrink, object: viewModel.drinks[1])
                        }
                        Button("Remove \(viewModel.drinks[1].toLocal())",
                               role: .destructive) {
                            viewModel.removeDrink(viewModel.drinks[1])
                        }
                    }
                    .frame(width: geo.size.width / 3,
                           height: 180,
                           alignment: .bottom)
                    DrinkView(viewModel: viewModel,
                              drink: $viewModel.drinks[2],
                              disable: false) {
                        viewModel.addDrink(viewModel.drinks[2])
                    }
                    .contextMenu {
                        Button(Localizable.editDrink.local(viewModel.language)) {
                            NotificationCenter.default.post(name: .editDrink, object: viewModel.drinks[2])
                        }
                        Button("Remove \(viewModel.drinks[2].toLocal())",
                               role: .destructive) {
                            viewModel.removeDrink(viewModel.drinks[2])
                        }
                    }
                    .frame(width: geo.size.width / 3,
                           height: 250,
                           alignment: .bottom)
                }
                .position(x: geo.size.width / 2, y: geo.size.height / 3)
            }
            .padding(.horizontal, 24)

            Spacer()

            HStack {
                Button {
                    viewModel.navigateToSettings()
                } label: {
                    Image.settings
                        .font(.brandLargeHeader)
                        .foregroundColor(.button)
                }

                Spacer()

                Button {
                    viewModel.navigateToCalendar()
                } label: {
                    Image.calender
                        .font(.brandLargeHeader)
                        .foregroundColor(.button)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.fetchToday()
            viewModel.fetchHealthData()
        }
        .onAppear {
            viewModel.updateDrinks()
            viewModel.fetchToday()
        }
        .background(Color.background.ignoresSafeArea())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView { _ in }
    }
}
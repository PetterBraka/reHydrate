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
                .font(.largeHeader)
                .bold()
            Text(viewModel.getDate())
                .font(.title)
            Text("\(viewModel.getConsumed())/\(viewModel.getGoal())L")
                .font(.extraLargeTitle)
                .bold()
            
            Spacer()
            
            GeometryReader { geo in
                HStack(alignment: .bottom) {
                    DrinkView(drink: $viewModel.drinks[0],
                              disable: false) {
                        viewModel.addDrink(viewModel.drinks[0])
                    } longPress: {
                        viewModel.interactedDrink = viewModel.drinks[0]
                        viewModel.showAlert.toggle()
                    }
                    .frame(width: geo.size.width / 3,
                           height: 100,
                           alignment: .bottom)
                    DrinkView(drink: $viewModel.drinks[1],
                              disable: false) {
                        viewModel.addDrink(viewModel.drinks[1])
                    } longPress: {
                        viewModel.interactedDrink = viewModel.drinks[1]
                        viewModel.showAlert.toggle()
                    }
                              .frame(width: geo.size.width / 3,
                                     height: 180,
                                     alignment: .bottom)
                    DrinkView(drink: $viewModel.drinks[2],
                              disable: false) {
                        viewModel.addDrink(viewModel.drinks[2])
                    } longPress: {
                        viewModel.interactedDrink = viewModel.drinks[2]
                        viewModel.showAlert.toggle()
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
                        .font(.largeHeader)
                        .foregroundColor(.button)
                }
                
                Spacer()
                
                Button {
                    viewModel.navigateToCalendar()
                } label: {
                    Image.calender
                        .font(.largeHeader)
                        .foregroundColor(.button)
                }
            }
            .padding(.horizontal, 24)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.fetchToday()
        }
        .confirmationDialog("Drink options",
                            isPresented: $viewModel.showAlert) {
            Button("Remove \(viewModel.getValue(for: viewModel.interactedDrink))mL",
                   role: .destructive) {
                if let drink = viewModel.interactedDrink {
                    viewModel.removeDrink(drink)
                }
            }
        }
        .background(Color.background.ignoresSafeArea())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView() {_ in }
    }
}

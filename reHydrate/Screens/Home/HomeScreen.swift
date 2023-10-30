//
//  HomeScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import HomePresentationInterface
import PresentationKit
import EngineKit

struct HomeScreen: View {
    @ObservedObject var observer: HomeScreenObservable

    var body: some View {
        VStack(spacing: 16) {
            header
                .task {
                    await observer.perform(action: .didAppear)
                }

            Spacer()

            drinksSection
                .padding(.horizontal, 24)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            navigationBar
        }
        .background(Color.background)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }

    @ViewBuilder
    private var header: some View {
        VStack(spacing: 8) {
            Text(LocalizedString("ui.app,title.text",
                                   value: "reHydrate",
                                   comment: "The name of the app"))
                .font(.brandTitle3)
                .bold()
            Text(observer.viewModel.date.localized)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .font(.brandTitle2)
            Text("\(observer.viewModel.consumption.clean)" +
                 "/" +
                 "\(observer.viewModel.goal.clean)" +
                 "\(observer.viewModel.largeUnit.symbol)")
                .font(.brandTitle3)
                .bold()
                .padding(.top, 16)
        }
    }

    @ViewBuilder
    private var drinksSection: some View {
        HStack(alignment: .bottom) {
            ForEach(observer.viewModel.drinks, id: \.id) { drink in
                let index = observer.viewModel.drinks.firstIndex(of: drink) ?? 0
                DrinkView(
                    fill: drink.fill,
                    size: drink.size,
                    unit: observer.viewModel.smallUnit,
                    containerType: drink.container
                ) {
                    observer.perform(action: .didTapAddDrink(drink))
                } menuItems: {
                    contextMenuContent(for: drink)
                }
                .frame(maxHeight: (100 * CGFloat(index + 1)),
                       alignment: .bottom)
                .frame(maxWidth: .infinity)
                .contextMenu {
                    contextMenuContent(for: drink)
                }
            }
        }
    }
    
    @ViewBuilder
    private func contextMenuContent(for drink: Home.ViewModel.Drink) -> some View {
        Button(LocalizedString(
            "ui.home.editDrink.button",
            value: "Edit drink",
            comment: "An button to edit the a drink."
        )) {
            observer.perform(action: .didTapEditDrink(drink))
        }
        Button(LocalizedString(
            "ui.home.removeDrink.button",
            value: "Remove \(drink.size.clean)\(observer.viewModel.smallUnit.symbol)",
            comment: "An button to remove a drink of a given size and unit"
        ),
               role: .destructive) {
            observer.perform(action: .didTapRemoveDrink(drink))
        }
    }
    
    @ViewBuilder
    private var navigationBar: some View {
        HStack {
            Button {
                observer.perform(action: .didTapSettings)
            } label: {
                Image.settings
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64)
                    .font(.brandLargeHeader)
                    .foregroundColor(.button)
            }
            
            Spacer()
            
            Button {
                observer.perform(action: .didTapHistory)
            } label: {
                Image.calendar
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64)
                    .font(.brandLargeHeader)
                    .foregroundColor(.button)
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeScreen(observer: HomeScreenObservable(
        presenter: Screen.Home.Presenter(
            engine: Engine.mock,
            router: Router())
    ))
}

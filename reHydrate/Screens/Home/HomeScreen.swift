//
//  HomeScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import PresentationInterface
import PresentationKit
import EngineKit

struct HomeScreen: View {
    @Environment(\.colorScheme) var colorScheme
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
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }

    @ViewBuilder
    private var header: some View {
        VStack(spacing: 8) {
            Text(LocalizedString("ui.app,title.text",
                                 value: "reHydrate",
                                 comment: "The name of the app"))
            .font(.Theme.extraLargeTitle)
            .bold()
            Text(observer.viewModel.dateTitle)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .font(.Theme.title2)
            Text("\(observer.viewModel.consumption.clean)" +
                 "/" +
                 "\(observer.viewModel.goal.clean)" +
                 "\(observer.viewModel.largeUnit.symbol)")
            .font(.Theme.title2)
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
            }
            Spacer()
            Button {
                observer.perform(action: .didTapHistory)
            } label: {
                Image.calendar
            }
        }
        .font(.Theme.extraLargeTitle2)
        .tint(.secondary)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .zIndex(2)
    }
}

#Preview {
    HomeScreen(
        observer: HomeScreenObservable(
            presenter: Screen.Home.Presenter(
                engine: Engine.mock,
                router: Router(),
                formatter: {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEE - dd MMM"
                    formatter.locale = .current
                    return formatter
                }()
            )
        )
    )
}

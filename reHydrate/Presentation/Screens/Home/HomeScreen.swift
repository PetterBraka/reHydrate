//
//  HomeScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var observer: HomeScreenObservable

    var body: some View {
        VStack(spacing: 16) {
            header

            Spacer()

            drinksSection
                .padding(.horizontal, 24)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            navigationBar
        }
        .background(Color.background.ignoresSafeArea())
    }

    @ViewBuilder
    private var header: some View {
        VStack(spacing: 16) {
            Text(String(localized: "ui.app,title.text",
                        defaultValue: "reHydrate",
                        comment: "The name of the app"))
                .font(.brandTitle3)
                .bold()
            Text(observer.date.localized)
                .font(.brandTitle)
            Text("\(observer.consumed.clean)" +
                 "/" +
                 "\(observer.goal.clean)")
                .font(.brandTitle3)
                .bold()
        }
    }

    @ViewBuilder
    private var drinksSection: some View {
        HStack(alignment: .bottom) {
            ForEach(observer.drinks) { drink in
                let index = observer.drinks.firstIndex(of: drink) ?? 0
                DrinkView(
                    fill: drink.fill,
                    size: drink.size,
                    unit: observer.unit.small,
                    containerType: drink.type
                ) {
                    // TODO: Add support to consume a drink
                }
                .frame(maxHeight: (100 * CGFloat(index + 1)),
                       alignment: .bottom)
                .frame(maxWidth: .infinity)
                .contextMenu {
                    Button(String(
                        localized:
                        "ui.home.editDrink.button",
                        defaultValue: "Edit drink",
                        comment: "An button to edit the a drink."
                    )) {
                        // TODO: Add support to edit drink
                    }
                    Button(String(
                        localized: "ui.home.removeDrink.button",
                        defaultValue: "Remove \(drink.fill)\(observer.unit.small.symbol)",
                        comment: "An button to remove a drink of a given size and unit"
                    ),
                    role: .destructive) {
                        // TODO: Add support to remove drink
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var navigationBar: some View {
        HStack {
            Button {
                // TODO: Add support to navigate to settings
            } label: {
                Image.settings
                    .font(.brandLargeHeader)
                    .foregroundColor(.button)
            }
            
            Spacer()
            
            Button {
                // TODO: Add support to navigate to history
            } label: {
                Image.calendar
                    .font(.brandLargeHeader)
                    .foregroundColor(.button)
            }
        }
        .padding(.horizontal, 24)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(observer: .init(date: .now,
                                   consumed: 0,
                                   goal: 0,
                                   drinks: [
                                    .init(type: .small, size: 300),
                                    .init(type: .medium, size: 500),
                                    .init(type: .large, size: 750)
                                   ],
                                   unit: (small: .milliliters, large: .liters)))
    }
}

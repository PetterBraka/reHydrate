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
        .onAppear {
            Task(priority: .high) {
               observer.perform(action: .didAppear)
            }
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
            Text(String(localized: "ui.app,title.text",
                        defaultValue: "reHydrate",
                        comment: "The name of the app"))
                .font(.brandTitle3)
                .bold()
            Text(observer.date.localized)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .font(.brandTitle2)
            Text("\(observer.consumed.clean)" +
                 "/" +
                 "\(observer.goal.clean)" +
                 "\(observer.unit.large.symbol)")
                .font(.brandTitle3)
                .bold()
                .padding(.top, 16)
        }
    }

    @ViewBuilder
    private var drinksSection: some View {
        HStack(alignment: .bottom) {
            ForEach(observer.drinks, id: \.id) { drink in
                let index = observer.drinks.firstIndex(of: drink) ?? 0
                DrinkView(
                    fill: drink.fill,
                    size: drink.size,
                    unit: observer.unit.small,
                    containerType: drink.container
                ) {
                    observer.perform(action: .didTapAddDrink(drink))
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
                        observer.perform(action: .didTapEditDrink(drink))
                    }
                    Button(String(
                        localized: "ui.home.removeDrink.button",
                        defaultValue: "Remove \(drink.size.clean)\(observer.unit.small.symbol)",
                        comment: "An button to remove a drink of a given size and unit"
                    ),
                    role: .destructive) {
                        observer.perform(action: .didTapRemoveDrink(drink))
                    }
                }
            }
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

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(observer: .mock)
    }
}

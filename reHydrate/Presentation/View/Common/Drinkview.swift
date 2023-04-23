//
//  DrinkView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct DrinkView: View {
    private let settingsRepository: SettingsRepository = MainAssembler.resolve()
    var isMetric: Bool { settingsRepository.isMetric }
    @ObservedObject var viewModel: HomeViewModel

    @Binding var drink: Drink
    var disable: Bool
    var tapAction: () -> Void

    var body: some View {
        Button {
            tapAction()
        } label: {
            VStack {
                drink.type.getImage(with: drink.fill)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .contrast(disable ? 0.1 : 1)
                Text(getValue(for: drink))
                    .font(.brandBody)
                    .foregroundColor(.label)
            }
        }
    }

    func getValue(for drink: Drink?) -> String {
        if let drink = drink {
            let drinkValue = drink.size.convert(to: isMetric ? .milliliters : .imperialPints, from: .milliliters)
            return drinkValue.clean + (isMetric ? "ml" : "pt")
        } else {
            return ""
        }
    }
}

struct DrinkView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkView(viewModel: HomeViewModel(navigateTo: { _ in }),
                  drink: .constant(Drink(type: .medium, size: 500)),
                  disable: true) {}
    }
}
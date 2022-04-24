//
//  EditDrinkView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 26/02/2022.
//  Copyright © 2022 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct EditDrinkView: View {
    @AppStorage("language") private var language = LocalizationService.shared.language
    @StateObject var viewModel: EditDrinkViewModel

    var action: () -> Void

    init(drink: Drink, save: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: EditDrinkViewModel(drink: drink))
        action = save
    }

    var body: some View {
        VStack {
            HStack {
                WaveView(color: .blue,
                         fillLevel: $viewModel.fillLevel,
                         currentFill: $viewModel.fillLabel,
                         minFillLevel: viewModel.minFill,
                         maxFillLevel: viewModel.maxFill,
                         emptySpace: viewModel.emptySpace) {
                    viewModel.selectedDrink.type.getImage(with: 0)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .aspectRatio(contentMode: .fit)
                Slider(value: $viewModel.fillLevel,
                       in: viewModel.minFill ... viewModel.maxFill)
                    .rotationEffect(Angle(degrees: -90))
            }
            .padding(.vertical, 24)
            Button {
                viewModel.saveDrink()
                action()
            } label: {
                HStack {
                    Spacer()
                    Text(Localizable.done.local(language))
                    Spacer()
                }
            }
            .tint(.blue)
            .padding(8)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background)
        )
        .padding(24)
    }
}

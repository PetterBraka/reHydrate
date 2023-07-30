//
//  DrinkView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import HomePresentationInterface

struct DrinkView: View {
    typealias Container = Home.ViewModel.Container
    
    private let fill: Double
    private let size: Double
    private let unit: UnitVolume
    private let containerType: Container

    private let didTapAction: () -> Void
    
    init(fill: Double,
         size: Double,
         unit: UnitVolume,
         containerType: Container,
         didTapAction: @escaping () -> Void) {
        self.fill = fill
        self.size = size
        self.unit = unit
        self.containerType = containerType
        self.didTapAction = didTapAction
    }

    var body: some View {
        Button {
            didTapAction()
        } label: {
            VStack {
                getImage(fill: fill, type: containerType)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("\(size.clean) \(unit.symbol)")
                    .font(.brandBody)
                    .foregroundColor(.label)
            }
        }
    }

    private func getImage(fill: Double, type: Container) -> Image {
        switch type {
        case .small: return .getGlass(with: fill)
        case .medium: return .getBottle(with: fill)
        case .large: return .getReusableBottle(with: fill)
        }
    }
}

struct DrinkView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            DrinkView(fill: 0.5,
                      size: 500,
                      unit: .milliliters,
                      containerType: .medium) {}
            DrinkView(fill: 0.75,
                      size: 700,
                      unit: .milliliters,
                      containerType: .medium) {}
                .disabled(true)
        }
    }
}

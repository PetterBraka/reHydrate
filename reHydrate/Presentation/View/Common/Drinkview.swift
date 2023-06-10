//
//  DrinkView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreInterfaceKit
import SwiftUI

struct DrinkView: View {
    let fill: Double
    let size: Double
    let unit: UnitVolume
    let containerType: DrinkType

    let didTapAction: () -> Void

    var body: some View {
        Button {
            didTapAction()
        } label: {
            VStack {
                getImage(fill: fill, type: containerType)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("\(size.clean)\(unit.symbol)")
                    .font(.brandBody)
                    .foregroundColor(.label)
            }
        }
    }

    func getImage(fill: Double, type: DrinkType) -> Image {
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

//
//  DrinkView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import HomePresentationInterface

struct DrinkView<MenuItems: View>: View {
    typealias Container = Home.ViewModel.Container
    
    private let fill: Double
    private let size: Double
    private let unit: UnitVolume
    private let containerType: Container

    private let didTapAction: () -> Void
    
    private let menuItems: () -> MenuItems
    
    init(fill: Double,
         size: Double,
         unit: UnitVolume,
         containerType: Container,
         didTapAction: @escaping () -> Void,
         menuItems: @escaping () -> MenuItems) {
        self.fill = fill
        self.size = size
        self.unit = unit
        self.containerType = containerType
        self.didTapAction = didTapAction
        self.menuItems = menuItems
    }

    var body: some View {
        VStack {
            Button {
                didTapAction()
            } label: {
                getImage(fill: fill, type: containerType)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(alignment: .topTrailing) {
                    }
            }
            HStack {
                Text("\(size.clean) \(unit.symbol)")
                    .font(.brandBody)
                    .foregroundColor(.label)
                Menu {
                    menuItems()
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                }
                .tint(.button.opacity(0.75))
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

#Preview {
    DrinkView(fill: 0.5, size: 500, unit: .milliliters, containerType: .medium) {
        print("Did tap button")
    } menuItems: {
        Text("Menu item")
    }
}

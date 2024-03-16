//
//  DrinkView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import PresentationInterface

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
            }
            HStack {
                Text("\(size.clean) \(unit.symbol)")
                    .font(.Theme.callout)
                Menu {
                    menuItems()
                } label: {
                    Image.ellipsis
                }
                .font(.caption2)
                .foregroundStyle(.tertiary)
            }
        }
    }

    private func getImage(fill: Double, type: Container) -> Image {
        switch type {
        case .small:
            switch fill {
            case 0:
                Image(.glassFill0)
            case 0.1 ... 0.3:
                Image(.glassFill25)
            case 0.3 ... 0.6:
                Image(.glassFill50)
            case 0.6 ... 0.8:
                Image(.glassFill75)
            default:
                Image(.glassFill100)
            }
        case .medium:
            switch fill {
            case 0:
                Image(.bottleFill0)
            case 0.1 ... 0.3:
                Image(.bottleFill25)
            case 0.3 ... 0.6:
                Image(.bottleFill50)
            case 0.6 ... 0.8:
                Image(.bottleFill75)
            default:
                Image(.bottleFill100)
            }
        case .large:
            switch fill {
            case 0:
                Image(.reusableBottleFill0)
            case 0.1 ... 0.3:
                Image(.reusableBottleFill25)
            case 0.3 ... 0.6:
                Image(.reusableBottleFill50)
            case 0.6 ... 0.8:
                Image(.reusableBottleFill75)
            default:
                Image(.reusableBottleFill100)
            }
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

//
//  HomeView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct Drink: Identifiable, Hashable {
    var id = UUID()
    
    enum type {
        case small
        case medium
        case large
        
        func getImage() -> Image {
            switch self {
            case .small: return Image.cup
            case .medium: return Image.bottle
            case .large: return Image.largeBottle
            }
        }
    }
    
    var type: type
    var size: Int
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @Binding var drinks: [Drink]
    
    init(drinks: Binding<[Drink]>, navigateTo: @escaping ((AppState) -> Void)) {
        _drinks = drinks
        let viewModel = MainAssembler.shared.container.resolve(HomeViewModel.self,
                                                               argument: navigateTo)!
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("reHydrate")
                .font(.largeHeader)
                .bold()
            Text(viewModel.getDate())
                .font(.title)
            Text("\(viewModel.getConsumed())/\(viewModel.getGoal())L")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            GeometryReader { geo in
                HStack(alignment: .bottom) {
                    DrinkView(drink: $drinks[0],
                              disable: false) {
                        viewModel.addDrink(of: drinks[0])
                    } longPress: {
                        viewModel.interactedDrink = drinks[0]
                        viewModel.showAlert.toggle()
                    }
                    .frame(width: geo.size.width / 3,
                           height: 100,
                           alignment: .bottom)
                    DrinkView(drink: $drinks[1],
                              disable: false) {
                        viewModel.addDrink(of: drinks[1])
                    } longPress: {
                        viewModel.interactedDrink = drinks[1]
                        viewModel.showAlert.toggle()
                    }
                              .frame(width: geo.size.width / 3,
                                     height: 180,
                                     alignment: .bottom)
                    DrinkView(drink: $drinks[2],
                              disable: false) {
                        viewModel.addDrink(of: drinks[2])
                    } longPress: {
                        viewModel.interactedDrink = drinks[2]
                        viewModel.showAlert.toggle()
                    }
                              .frame(width: geo.size.width / 3,
                                     height: 250,
                                     alignment: .bottom)
                }
                .position(x: geo.size.width / 2, y: geo.size.height / 3)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            HStack {
                Button {
                    viewModel.navigateTo(.settings)
                } label: {
                    Image.settings
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.label)
                }
                
                Spacer()
                
                Button {
                    viewModel.navigateTo(.calender)
                } label: {
                    Image.calender
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.label)
                }
            }
            .frame(height: 50)
            .padding(.horizontal, 24)
        }
        .confirmationDialog("Drink options",
                            isPresented: $viewModel.showAlert) {
            Button("Remove \(viewModel.getCurrentDrink())mL",
                   role: .destructive) {
                if let drink = viewModel.interactedDrink {
                    viewModel.removeDrink(of: drink)
                }
            }
        }
        .background(Color.background.ignoresSafeArea())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(drinks: .constant([Drink(type: .small, size: 250),
                                    Drink(type: .medium, size: 500),
                                    Drink(type: .large, size: 750)])) {_ in }
    }
}

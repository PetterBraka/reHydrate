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

struct DayRecord {
    var date: Date
    var consumed: Double
    var goal: Double
}

struct HomeView: View {
    @Binding var drinks: [Drink]
    @Binding var today: DayRecord
    
    var navigateTo: (AppState) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("reHydrate")
                .font(.largeHeader)
                .bold()
            Text("Monday - 15/11/21")
                .font(.title)
            Text("0/2L")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            GeometryReader { geo in
                HStack(alignment: .bottom) {
                    DrinkView(drink: $drinks[0],
                              disable: false) {}
                              .frame(width: geo.size.width / 3,
                                     height: 100,
                                     alignment: .bottom)
                    DrinkView(drink: $drinks[1],
                              disable: false) {}
                              .frame(width: geo.size.width / 3,
                                     height: 180,
                                     alignment: .bottom)
                    DrinkView(drink: $drinks[2],
                              disable: false) {}
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
                    navigateTo(.settings)
                } label: {
                    Image.settings
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.label)
                }
                
                Spacer()
                
                Button {
                    navigateTo(.calender)
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
        .background(Color.background.ignoresSafeArea())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(drinks: .constant([Drink(type: .small, size: 250),
                                    Drink(type: .medium, size: 500),
                                    Drink(type: .large, size: 750)]),
                 today: .constant(DayRecord(date: Date(),
                                            consumed: 0.4,
                                            goal: 3))) {_ in }
    }
}

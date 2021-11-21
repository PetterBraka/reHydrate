//
//  DrinkView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct DrinkView: View {
    @Binding var drink: Drink
    var disable: Bool
    var tapAction: () -> Void
    var longPress: () -> Void
    
    var body: some View {
        Button {} label: {
            VStack {
                drink.type.getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .contrast(disable ? 0.1 : 1)
                Text("\(drink.size)mL")
                    .font(.body)
                    .foregroundColor(.label)
            }
        }
        .simultaneousGesture(
            LongPressGesture()
                .onEnded({ success in
                    if success {
                        longPress()
                    }
                })
        )
        .highPriorityGesture(
            TapGesture()
                .onEnded({ _ in
                    tapAction()
                })
        )
    }
}

struct DrinkView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkView(drink: .constant(Drink(type: .medium, size: 500)),
                  disable: true) {} longPress: {}
    }
}

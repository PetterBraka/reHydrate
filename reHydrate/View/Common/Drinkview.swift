//
//  DrinkView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct DrinkView: View {
    @Preference(\.isUsingMetric) private var isMetric
    @ObservedObject var viewModel: HomeViewModel

    @Binding var drink: Drink
    @State var subtitle: String = ""
    var disable: Bool
    var tapAction: () -> Void
    var longPress: () -> Void

    var body: some View {
        Button {} label: {
            VStack {
                drink.type?.getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .contrast(disable ? 0.1 : 1)
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.label)
            }
        }
        .highPriorityGesture(
            LongPressGesture(minimumDuration: 0.2, maximumDistance: 0.3)
                .onEnded { success in
                    if success {
                        longPress()
                    }
                }
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    tapAction()
                }
        )
        .onAppear {
            subtitle = viewModel.getValue(for: drink)
        }
    }
}

struct DrinkView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkView(viewModel: HomeViewModel(presistenceController: PresistenceController(),
                                           navigateTo: { _ in}),
                  drink: .constant(Drink(type: .medium, size: 500)),
                  disable: true) {} longPress: {}
    }
}
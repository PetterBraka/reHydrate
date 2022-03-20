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

    var body: some View {
        Button {
            tapAction()
        } label: {
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
        .onAppear {
            subtitle = viewModel.getValue(for: drink)
        }
    }
}

struct DrinkView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkView(viewModel: HomeViewModel(presistenceController: PresistenceController(),
                                           navigateTo: { _ in }),
                  drink: .constant(Drink(type: .medium, size: 500)),
                  disable: true) {}
    }
}

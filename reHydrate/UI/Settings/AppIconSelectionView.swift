//
//  AppIconSelectionView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 06/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct AppIconSelectionView: View {
    @AppStorage("language") var language = LocalizationService.shared.language
    
    @State var icons: [Image] = Image.icons
    @State var selectedIcon: Image = .blackWhite
    var dismiss: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                          alignment: .center, spacing: 16) {
                    ForEach(0..<icons.count, id: \.self) { index in
                        Button {
                            selectedIcon = icons[index]
                        } label: {
                            icons[index]
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(.blue.opacity(0.9),
                                            lineWidth: (icons[index] == selectedIcon) ? 5 : 0))
                        .padding(8)
                    }
                }
            }
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(id: "done button", placement: .navigationBarTrailing) {
                    Button(Localizable.done, role: .cancel) {
                        dismiss()
                    }
                    .foregroundColor(.label)
                }
                ToolbarItem(placement: .principal) {
                    Text(Localizable.Setting.appIcon.local(language))
                }
            }
        }
    }
}

struct AppIconSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconSelectionView() {}
    }
}

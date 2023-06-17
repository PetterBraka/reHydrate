//
//  AppIconSelectionView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 06/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct AppIconSelectionView: View {
    @EnvironmentObject var iconSettings: IconHelper
    @State var selectedIcon: Icon
    var dismiss: () -> Void

    init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
        if let currentIcon = UIApplication.shared.alternateIconName,
           let icon = Icon(rawValue: currentIcon) {
            selectedIcon = icon
        } else {
            selectedIcon = .blackWhite
        }
        print(selectedIcon)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                          alignment: .center, spacing: 16) {
                    ForEach(iconSettings.iconNames, id: \.self) { icon in
                        Button {
                            guard selectedIcon != icon else { return }
                            selectedIcon = icon
                            UIApplication.shared.setAlternateIconName(icon.rawValue) { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    print(icon.rawValue)
                                    print("Success!")
                                }
                            }
                        } label: {
                            Image(uiImage: UIImage(named: icon.rawValue) ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue,
                                    lineWidth: (icon.rawValue == selectedIcon.rawValue) ? 4 : 0))
                        .padding(8)
                    }
                }
            }
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(id: "done button", placement: .navigationBarTrailing) {
                    Button(String(localized: "ui.done", defaultValue: "Done"), role: .cancel) {
                        dismiss()
                    }
                    .foregroundColor(.label)
                    .font(.brandTitle)
                }
                ToolbarItem(placement: .principal) {
                    Text(String(localized: "ui.settings.appIcon.title", defaultValue: "Change app icon"))
                        .font(.brandTitle)
                }
            }
        }
    }
}

struct AppIconSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconSelectionView {}
    }
}

//
//  CreditsView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 29/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct CreditsView: View {
    struct Credit: Hashable {
        var name, webSite, icons: String
    }

    @State var credits: [Credit] =
        [
            Credit(name: "Petter Vang Braklsvålet",
                   webSite: "https://petterbraka.github.io/LinkTree/",
                   icons: "🌎 🇳🇴"),
            Credit(name: "Alexandra Murphy",
                   webSite: "https://beacons.page/alexsmurphy",
                   icons: "🌎 🇬🇧"),
            Credit(name: "Leo Mehing",
                   webSite: "https://structured.today",
                   icons: "🌎 🇩🇪"),
            Credit(name: "Sævar Ingi Siggason",
                   webSite: "",
                   icons: "🇮🇸")
        ]
    var dismiss: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(credits, id: \.self) { credit in
                        Button {
                            openLink(to: credit.webSite)
                        } label: {
                            HStack {
                                Text(credit.name)
                                Spacer()
                                Text(credit.icons)
                            }
                            .contentShape(Rectangle())
                        }
                        .font(.brandBody)
                        .foregroundColor(.label)
                        if credit != credits.last {
                            Divider()
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.tableViewBackground)
                )
                .padding(.bottom, 8)
                Button {
                    openLink(to: .helpTranslate)
                } label: {
                    HStack {
                        Text(String(localized: "ui.settings.credits.helpTranslate",
                                    defaultValue: "Help translate the app"))
                        Spacer()
                        Image.open
                    }
                    .contentShape(Rectangle())
                    .font(.brandBody)
                    .foregroundColor(.label)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.tableViewBackground)
                )
            }
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(String(localized: "ui.done", defaultValue: "Done"), role: .cancel) {
                        dismiss()
                    }
                    .foregroundColor(.label)
                    .font(.brandTitle)
                }
            }
        }
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView {}
    }
}

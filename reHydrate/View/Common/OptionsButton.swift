//
//  OptionsButton.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 30/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct OptionsButton: View {
    @State var title: String
    @Binding var selectedItem: String
    @State var items: [String]
    @Binding var language: Language
    @State var isTapped = false

    var body: some View {
        HStack {
            Text(title.local(language))
                .font(.body)
            Spacer()
            Button(LocalizedStringKey(selectedItem)) {
                isTapped.toggle()
            }
            .font(.body)
            .tint(.label)
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder()
                    .foregroundColor(.label)
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isTapped.toggle()
        }
        .alert(title.local(language), isPresented: $isTapped, actions: {
            ForEach(items, id: \.self) { item in
                if let index = items.firstIndex(of: item) {
                    Button {
                        selectedItem = item
                    } label: {
                        Text(LocalizedStringKey(items[index]))
                    }
                }
            }
            Button(LocalizedStringKey(Localizable.cancel), role: .cancel) {}
        })
    }
}

struct DropDownButton_Previews: PreviewProvider {
    static var previews: some View {
        OptionsButton(title: "", selectedItem: .constant(""), items: [], language: .constant(.english))
    }
}

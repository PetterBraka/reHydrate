//
//  CheckBox.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 30/07/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct CheckBoxButton: View {
    @Binding var isChecked: Bool
    
    @State var text: String
    @State var highlightedText: String
    @State var image: Image
    @State var highlightedImage: Image
    
    var body: some View {
        Button {
            withAnimation {
                isChecked.toggle()
            }
        } label: {
            HStack {
                Text(isChecked ? highlightedText : text)
                Spacer()
                if isChecked {
                    highlightedImage
                        .font(.Theme.title2)
                        .foregroundStyle(.secondary)
                } else {
                    image
                        .font(.Theme.title2)
                        .foregroundStyle(.tertiary)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

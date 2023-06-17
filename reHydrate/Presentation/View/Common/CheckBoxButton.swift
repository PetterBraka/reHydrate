//
//  CheckBoxButton.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct CheckBoxButton: View {
    @Binding var isChecked: Bool

    @State var text: String
    @State var highlightedText: String
    @State var image: Image
    @State var highlightedImage: Image

    var rowAction: () -> Void

    var body: some View {
        Button {
            withAnimation {
                rowAction()
            }
        } label: {
            HStack {
                Text(isChecked ? highlightedText : text)
                    .font(.brandBody)
                    .foregroundColor(.label)
                Spacer()
                if isChecked {
                    highlightedImage
                        .font(.brandTitle2)
                        .foregroundColor(.button)
                } else {
                    image
                        .font(.brandTitle2)
                        .foregroundColor(.button)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                withAnimation {
                    rowAction()
                }
            }
        }
    }
}

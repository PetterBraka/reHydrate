//
//  CheckBoxButton.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreKit
import SwiftUI

struct CheckBoxButton: View {
    @Binding var isChecked: Bool

    @State var text: String
    @State var highlightedText: String
    @State var image: Image
    @State var highlightedImage: Image
    var language: Language

    var rowAction: () -> Void

    var body: some View {
        Button {
            withAnimation {
                rowAction()
            }
        } label: {
            HStack {
                Text(isChecked ? highlightedText.local(language) : text.local(language))
                    .font(.brandBody)
                    .foregroundColor(.label)
                Spacer()
                if isChecked {
                    highlightedImage
                        .font(.brandLargeTitle)
                        .foregroundColor(.button)
                } else {
                    image
                        .font(.brandLargeTitle)
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

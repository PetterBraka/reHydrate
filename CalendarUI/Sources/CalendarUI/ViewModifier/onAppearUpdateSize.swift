//
//  OnAppearUpdateSize.swift
//
//
//  Created by Petter vang Brakalsvålet on 13/12/2023.
//

import SwiftUI

extension View {
    func onAppear(update size: Binding<CGSize>) -> some View {
        background {
            GeometryReader { proxy in
                Color.clear
                    .onAppear { size.wrappedValue = proxy.size }
            }
        }
    }
}

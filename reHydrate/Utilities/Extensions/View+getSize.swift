//
//  View+getSize.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct ViewSize: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background {
                backgroundCalculator
            }
    }
    
    @ViewBuilder
    var backgroundCalculator: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear {
                    size = proxy.size
                }
        }
    }
}

extension View {
    func getSize(_ size: Binding<CGSize>) -> some View {
        modifier(ViewSize(size: size))
    }
    
    func getHeight(_ height: Binding<CGFloat>) -> some View {
        let boundSize = Binding<CGSize> {
            CGSize(width: 0, height: height.wrappedValue)
        } set: {
            height.wrappedValue = $0.height
        }
        return modifier(ViewSize(size: boundSize))
    }
    
    func getWidth(_ width: Binding<CGFloat>) -> some View {
        let boundSize = Binding<CGSize> {
            CGSize(width: width.wrappedValue, height: 0)
        } set: {
            width.wrappedValue = $0.width
        }
        return modifier(ViewSize(size: boundSize))
    }
}

//
//  CustomToolbar.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct CustomToolbar<LeadingButton: View, TrailingButton: View>: View {
    let title: Text
    let leadingButton: LeadingButton?
    let trailingButton: TrailingButton?
    
    @State private var leadingPadding: CGFloat = 0
    @State private var trailingPadding: CGFloat = 0
    
    let background: Color
    
    var body: some View {
        ZStack {
            buttonsView
            titleView
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(backgroundView)
        .dynamicTypeSize(.xSmall ... .accessibility1)
    }
    
    @ViewBuilder
    var buttonsView: some View {
        HStack {
            leadingButton
            .getWidth($leadingPadding)
            Spacer()
            trailingButton
            .getWidth($trailingPadding)
        }
        .buttonStyle(.borderless)
    }
    
    @ViewBuilder
    var titleView: some View {
        let buttonPadding = max(leadingPadding, trailingPadding)
        title
            .multilineTextAlignment(.center)
            .padding(.leading, buttonPadding)
            .padding(.trailing, buttonPadding)
            .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var backgroundView: some View {
        Rectangle()
            .fill(background)
            .shadow(color: .black.opacity(0.25), radius: 2, y: 1)
            .ignoresSafeArea(.container, edges: .top)
    }
}

extension CustomToolbar {
    init(background: Color = .background,
         title: () -> Text,
         leadingButton: (() -> LeadingButton)? = nil,
         trailingButton: (() -> TrailingButton)? = nil) {
        self.title = title()
        self.leadingButton = leadingButton?()
        self.trailingButton = trailingButton?()
        self.background = background
    }
}

extension CustomToolbar where LeadingButton == EmptyView {
    init(background: Color = .background,
         title: () -> Text,
         trailingButton: () -> TrailingButton) {
        self.title = title()
        self.leadingButton = nil
        self.trailingButton = trailingButton()
        self.background = background
    }
}

extension CustomToolbar where TrailingButton == EmptyView {
    init(background: Color = .background,
         title: () -> Text,
         leadingButton: () -> LeadingButton) {
        self.title = title()
        self.leadingButton = leadingButton()
        self.trailingButton = nil
        self.background = background
    }
}

extension CustomToolbar where LeadingButton == EmptyView, 
                                TrailingButton == EmptyView {
    init(background: Color = .background,
         title: () -> Text) {
        self.title = title()
        self.leadingButton = nil
        self.trailingButton = nil
        self.background = background
    }
}

#Preview {
    VStack {
        CustomToolbar {
            Text("Title")
                .bold()
        }
        CustomToolbar {
            Text("A really long title which will be wrapped")
        } leadingButton: {
            Button("Leading", action: {})
        } trailingButton: {
            Button("Trailing", action: {})
                .tint(.red)
                .buttonStyle(.bordered)
        }
        Spacer()
    }
}

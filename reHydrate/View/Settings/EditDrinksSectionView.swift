//
//  EditDrinksSectionView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 29/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct EditDrinksSectionView: View {
    @FocusState var focusedField: SettingsView.Field?
    @Binding var small: String
    @Binding var medium: String
    @Binding var large: String
    @Binding var unit: String
    var language: Language

    var body: some View {
        // Small
        HStack {
            Text(Localizable.editSmall.local(language))
            Spacer()
            HStack(spacing: 0) {
                TextField("", text: $small, prompt: Text("Value"))
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .small)
                    .multilineTextAlignment(.center)
                    .fixedSize()
                Text(unit)
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder()
                    .foregroundColor(.label)
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = .small
        }
        // Medium
        HStack {
            Text(Localizable.editMedium.local(language))
            Spacer()
            HStack(spacing: 0) {
                TextField("", text: $medium, prompt: Text("Value"))
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .medium)
                    .multilineTextAlignment(.center)
                    .fixedSize()
                Text(unit)
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder()
                    .foregroundColor(.label)
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = .medium
        }
        // Large
        HStack {
            Text(Localizable.editLarge.local(language))
            Spacer()
            HStack(spacing: 0) {
                TextField("", text: $large, prompt: Text("Value"))
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .large)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .fixedSize()
                Text(unit)
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder()
                    .foregroundColor(.label)
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = .large
        }
    }
}

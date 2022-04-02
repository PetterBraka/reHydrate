//
//  EditDrinksSectionView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 29/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct EditDrinksSectionView: View {
    @Preference(\.isUsingMetric) private var isMetric
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
                    .onSubmit {
                        guard let value = Double(small) else { return }
                        var size = updateDrink(with: value, max: 400, min: 100)
                        let measurement = Measurement(value: size, unit: UnitVolume.milliliters)
                        size = measurement.converted(to: isMetric ? .milliliters : .imperialPints).value
                        small = size.clean
                    }
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
                    .onSubmit {
                        guard let value = Double(medium) else { return }
                        var size = updateDrink(with: value, max: 700, min: 300)
                        let measurement = Measurement(value: size, unit: UnitVolume.milliliters)
                        size = measurement.converted(to: isMetric ? .milliliters : .imperialPints).value
                        medium = size.clean
                    }
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
                    .onSubmit {
                        guard let value = Double(large) else { return }
                        var size = updateDrink(with: value, max: 1200, min: 500)
                        let measurement = Measurement(value: size, unit: UnitVolume.milliliters)
                        size = measurement.converted(to: isMetric ? .milliliters : .imperialPints).value
                        large = size.clean
                    }
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

    func updateDrink(with newValue: Double, max: Double, min: Double) -> Double {
        let unit = isMetric ? UnitVolume.milliliters : .imperialPints
        let size = Measurement(value: newValue, unit: unit)
        let metricSize = size.converted(to: .milliliters).value
        if metricSize >= max {
            return max
        } else if metricSize < min {
            return min
        } else {
            return metricSize
        }
    }
}

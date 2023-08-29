//
//  UnitSystemPicker.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 29/08/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import SettingsPresentationInterface
import PresentationKit

struct UnitSystemPicker<Content: View>: View {
    typealias UnitSystem = Screen.Settings.Presenter.ViewModel.UnitSystem
    var units: [UnitSystem]
    @Binding var selected: UnitSystem
    
    let background: Color = .gray.opacity(0.25)
    let fontColor: Color = .black
    let highlighted: (text: Color, background: Color) =
    (text: .white, background: .gray.opacity(0.5))
    
    @ViewBuilder var content: (UnitSystem) -> Content
    
    @Namespace var unitSystemPickerNamespace
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(units, id: \.self) { unit in
                let isSelected = unit == selected
                getContent(for: unit)
                    .onTapGesture {
                        guard !isSelected else { return }
                        withAnimation {
                            selected = unit
                        }
                    }
            }
        }
        .padding(4)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(background)
        }
    }
    
    @ViewBuilder
    func getContent(for unit: UnitSystem) -> some View {
        let isSelected = unit == selected
        content(unit)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(isSelected ? highlighted.text : fontColor)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(highlighted.background)
                        .matchedGeometryEffect(id: "Background",in: unitSystemPickerNamespace)
                }
            }
            .transition(.slide)
    }
}

struct UnitSystemPicker_Preview: View, PreviewProvider {
    static var previews: some View = UnitSystemPicker_Preview().body
    
    @State var selected: UnitSystemPicker.UnitSystem = .metric
    var body: some View {
        UnitSystemPicker(units: [.metric, .imperial], selected: $selected) { unit in
            switch unit {
            case .metric:
                Text("Metric")
            case .imperial:
                Text("Imperial")
            }
        }
    }
}

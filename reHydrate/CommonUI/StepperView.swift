//
//  StepperView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct StepperView: View {
    var value: String
    var onIncrement: () -> Void
    var onDecrement: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Button {
                onDecrement()
            } label: {
                Image.minus
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(.bordered)
            .foregroundColor(.label)
            
            Button {} label: {
                Text(value)
                    .font(.brandBody)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(height: 16)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .foregroundColor(.label)
            .tint(.buttonHighlighted)
            .shadow(radius: 1)
            
            Button {
                onIncrement()
            } label: {
                Image.plus
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(.bordered)
            .foregroundColor(.label)
        }
    }
}

#Preview {
    StepperView(value: "2") {
        print("increment")
    } onDecrement: {
        print("decrement")
    }
}

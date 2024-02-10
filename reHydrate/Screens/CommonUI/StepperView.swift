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
        HStack {
            Button(action: onDecrement) {
                Image.minus
                    .aspectRatio(contentMode: .fill)
            }
            .padding(4)
            .foregroundStyle(.primary)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.quaternary)
                    .aspectRatio(contentMode: .fill)
            }
            
            Text(value)
                .aspectRatio(contentMode: .fill)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .foregroundStyle(.primary)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.tertiary)
                }
                .padding(.horizontal, 4)
            
            Button(action: onIncrement){
                Image.plus
                    .aspectRatio(contentMode: .fill)
            }
            .foregroundStyle(.primary)
            .padding(4)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.quaternary)
                    .aspectRatio(contentMode: .fill)
            }
        }
        .font(.Theme.callout)
    }
}

#Preview {
    StepperView(value: "2") {
        print("increment")
    } onDecrement: {
        print("decrement")
    }
}

//
//  WaveView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 19/02/2022.
//  Copyright © 2022 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct WaveView: View {
    @State private var percent = 50.0
    @State private var waveOffset = Angle(degrees: 0)

    var body: some View {
        VStack {
            WaveShape(offset: Angle(degrees: self.waveOffset.degrees),
                      percent: Double(percent) / 100)
                .fill(Color.blue.opacity(0.8))
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 2)
                .repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}

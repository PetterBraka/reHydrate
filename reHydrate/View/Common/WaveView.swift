//
//  WaveView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 19/02/2022.
//  Copyright © 2022 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct WaveView<Content: View>: View {
    @State var color: Color
    @State var offsetPercent: CGFloat
    @State var isReversed: Bool = false
    @Binding var waterLevel: CGFloat
    @State var maxFillLevel: CGFloat = 0.7

    @ViewBuilder var container: Content

    var body: some View {
        ZStack {
            TimelineView(.animation) { timeLine in
                Canvas { context, size in
                    let now = timeLine.date.timeIntervalSinceReferenceDate
                    let angle = now.remainder(dividingBy: 2)
                    let offset = angle * size.width
                    context.translateBy(x: isReversed ? -offset : offset, y: 0)
                    context.fill(getPath(size: size), with: .color(color))
                    context.translateBy(x: -size.width, y: 0)
                    context.fill(getPath(size: size), with: .color(color))
                    context.translateBy(x: size.width * 2, y: 0)
                    context.fill(getPath(size: size), with: .color(color))
                }
            }
            .opacity(0.8)
            .mask {
                container
            }
            container
                .ignoresSafeArea()
        }
    }

    func getPath(size: CGSize) -> Path {
        Path { path in
            let fill = size.height * (1 - (waterLevel < maxFillLevel ? waterLevel : maxFillLevel))
            let width = size.width
            let maxOffset = size.height / 4
            path.move(to: CGPoint(x: 0, y: fill))
            path.addCurve(to: CGPoint(x: width, y: fill),
                          control1: CGPoint(x: width * 0.5,
                                            y: fill + maxOffset / 100 * offsetPercent),
                          control2: CGPoint(x: width * 0.5,
                                            y: fill - maxOffset / 100 * offsetPercent))

            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
        }
    }
}

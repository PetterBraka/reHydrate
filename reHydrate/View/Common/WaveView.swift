//
//  WaveView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 19/02/2022.
//  Copyright © 2022 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

/**
 Fills a container with moving water.
 */
struct WaveView<Content: View>: View {
    @State var color: Color
    @State var offsetPercent: CGFloat
    @State var maxOffset: CGFloat = 0.25
    @State var isReversed: Bool
    @Binding var fillLevel: CGFloat
    @State var maxFillLevel: CGFloat

    @ViewBuilder var container: Content

    /**
     Fills a container with moving water.

     - Parameters:
        - Color: The color of the water
        - OffsetPrecent: How many percent the wather will move up and down.
        - MaxOffset: The maximum hight of the water wave.
        - isReversed: Indecates if the water animation should move left to right or right to left.
        - fillLevel: How much of the container will be filled by the water
        - maxFillLevel: The max hight the water can fill.
        - container: The container that would be filled with water,

     # Example #
     ```
     WaveView(color: .blue,
              offsetPercent: 10,
              waterLevel: $waterLevel) {
         Image.largeBottle
             .resizable()
     }
     .aspectRatio(contentMode: .fit)
     ```
     */
    internal init(color: Color,
                  offsetPercent: CGFloat,
                  maxOffset: CGFloat = 0.25,
                  isReversed: Bool = false,
                  fillLevel: Binding<CGFloat>,
                  maxFillLevel: CGFloat = 0.7,
                  container: () -> Content) {
        _fillLevel = fillLevel
        _color = State(wrappedValue: color)
        _offsetPercent = State(wrappedValue: offsetPercent)
        _maxOffset = State(wrappedValue: maxOffset)
        _isReversed = State(wrappedValue: isReversed)
        _maxFillLevel = State(wrappedValue: maxFillLevel)
        self.container = container()
    }

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
            let fill = size.height * (1 - (fillLevel < maxFillLevel ? fillLevel : maxFillLevel))
            let width = size.width
            let maxOffset = size.height * self.maxOffset
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

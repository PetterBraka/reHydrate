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
    @Binding var currentFill: String
    @State var minFillLevel: CGFloat
    @State var maxFillLevel: CGFloat
    @State var emptySpace: CGFloat

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
                  offsetPercent: CGFloat = 10,
                  maxOffset: CGFloat = 0.25,
                  isReversed: Bool = false,
                  fillLevel: Binding<CGFloat>,
                  currentFill: Binding<String>,
                  minFillLevel: CGFloat = 0.2,
                  maxFillLevel: CGFloat = 0.7,
                  emptySpace: CGFloat,
                  container: () -> Content) {
        _fillLevel = fillLevel
        _currentFill = currentFill
        _color = State(wrappedValue: color)
        _offsetPercent = State(wrappedValue: offsetPercent)
        _maxOffset = State(wrappedValue: maxOffset)
        _isReversed = State(wrappedValue: isReversed)
        _minFillLevel = State(wrappedValue: minFillLevel)
        _maxFillLevel = State(wrappedValue: maxFillLevel)
        _emptySpace = State(wrappedValue: emptySpace)
        self.container = container()
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: emptySpace)
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
            }
            .opacity(0.8)
            .mask {
                container
            }
            container
            VStack {
                Spacer(minLength: emptySpace)
                GeometryReader { proxy in
                    Text(currentFill)
                        .font(.brandBody)
                        .padding(8)
                        .foregroundColor(.labelHighlighted)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.label)
                        )
                        .position(x: proxy.size.width / 2,
                                  y: proxy.size.height * (1 - fillLevel))
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    let dragHeight = -value.translation.height
                    let screenHeight = UIScreen.main.bounds.height
                    var relativeHight = min(0.01, dragHeight / screenHeight / 25)
                    relativeHight = max(-0.01, relativeHight)
                    let newHight = max(0.1, fillLevel + relativeHight)
                    withAnimation {
//                        fillLevel = newHight < maxFillLevel ? newHight : maxFillLevel
//                        if newHight > maxFillLevel {
//                            fillLevel = maxFillLevel
//                        } else if newHight < minFillLevel {
//                            fillLevel = minFillLevel
//                        } else {
                        fillLevel = newHight
//                        }
                    }
                }
        )
    }

    func getPath(size: CGSize) -> Path {
        Path { path in
            let fill = size.height * (1 - fillLevel)
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

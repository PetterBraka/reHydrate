//
//  FilledContainer.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 14/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct FilledContainer<Content: View>: View {
    var fill: CGFloat
    var waveHeight: CGFloat
    
    @ViewBuilder var container: Content
    
    var body: some View {
        container
            .background {
                water
                    .mask(alignment: .bottom) {
                        container
                    }
            }
    }
    
    var water: some View {
        TimelineView(.animation) { timeLine in
            Canvas { context, size in
                let now = timeLine.date.timeIntervalSinceReferenceDate
                let angle = now.remainder(dividingBy: 2)
                let offset = angle * size.width
                let path = getPath(size)
                context.translateBy(x: -offset, y: 0)
                context.fill(path, with: .color(.accentColor))
                context.translateBy(x: -size.width, y: 0)
                context.fill(path, with: .color(.accentColor))
                context.translateBy(x: size.width * 2, y: 0)
                context.fill(path, with: .color(.accentColor))
            }
        }
    }
    
    func getPath(_ size: CGSize) -> Path {
        Path { path in
            let fill = size.height * (1 - fill)
            let width = size.width
            let maxOffset = size.height * self.waveHeight
            path.move(to: CGPoint(x: 0, y: fill))
            path.addCurve(
                to: CGPoint(x: width, y: fill),
                control1: CGPoint(x: width * 0.5,
                                  y: fill + maxOffset / 100),
                control2: CGPoint(x: width * 0.5,
                                  y: fill - maxOffset / 100))
            
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
        }
    }
}

#Preview {
    FilledContainer(
        fill: 0.8,
        waveHeight: 5
    ) {
        Image.bottle
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

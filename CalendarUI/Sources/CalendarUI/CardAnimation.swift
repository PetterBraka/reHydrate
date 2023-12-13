//
//  CardAnimation.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/12/2023.
//

import SwiftUI

struct CardAnimation: ViewModifier {
    @State private var xOffset: CGFloat = .zero
    @State private var yOffset: CGFloat = .zero
    @State private var view: CGSize = .zero
    private let screen = UIScreen.main.bounds
    
    private var vTrigger: CGFloat { view.height / 2 }
    private var hTrigger: CGFloat { view.width / 2 }

    private let minimumDistance: CGFloat
    private let coordinateSpace: CoordinateSpace

    private let onEnd: (SwipeDirection) -> Void
    
    init(minimumDistance: CGFloat,
         coordinateSpace: CoordinateSpace,
         onEnd: @escaping (SwipeDirection) -> Void) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = coordinateSpace
        self.onEnd = onEnd
    }
    
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .offset(x: xOffset, y: yOffset)
            .animation(.default, value: xOffset)
            .animation(.default, value: yOffset)
            .simultaneousGesture(
                DragGesture(minimumDistance: minimumDistance,
                            coordinateSpace: coordinateSpace)
                .onChanged { value in
                    xOffset = value.translation.width
                    yOffset = value.translation.height
                }
                .onEnded { value in
                    if xOffset > hTrigger {
                        xOffset = screen.width
                    } else if xOffset < -hTrigger {
                        xOffset = -screen.width
                    } else {
                        xOffset = 0
                    }
                    if yOffset > vTrigger {
                        yOffset = screen.height
                    } else if yOffset < -vTrigger {
                        yOffset = -screen.height
                    } else {
                        yOffset = 0
                    }
                    if let direction = value.direction {
                        onEnd(direction)
                    }
                }
            )
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear { view = proxy.size }
                }
            }
    }
}

extension View {
    func cardAnimation(minimumDistance: CGFloat = 10,
                       coordinateSpace: CoordinateSpace = .global,
                       onEnd: @escaping (SwipeDirection) -> Void) -> some View {
        modifier(CardAnimation(
            minimumDistance: minimumDistance,
            coordinateSpace: coordinateSpace,
            onEnd: onEnd))
    }
}

#Preview {
    ZStack {
        ForEach(0 ..< 10, id: \.self) { _ in
            RoundedRectangle(cornerRadius: 25)
                .fill(.orange)
                .shadow(radius: 5)
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 200)
                .cardAnimation { direction in
                    print(direction)
                }
        }
    }
}

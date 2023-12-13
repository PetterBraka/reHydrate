//
//  CardAnimation.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/12/2023.
//

import SwiftUI

struct CardAnimation: ViewModifier {
    @State var xOffset: CGFloat = .zero
    @State var yOffset: CGFloat = .zero
    @State var viewSize: CGSize = .zero
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var swipeHTrigger: CGFloat { viewSize.width }
    var swipeVTrigger: CGFloat { viewSize.height }
    
    let onEnd: (SwipeDirection) -> Void
    let minimumDistance: CGFloat
    let coordinateSpace: CoordinateSpace
    
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
                    switch value.direction {
                    case .right:
                        if xOffset > swipeHTrigger {
                            xOffset = screenWidth
                            onEnd(.right)
                        } else {
                            xOffset = 0
                        }
                    case .left:
                        if xOffset < -swipeHTrigger {
                            xOffset = -screenWidth
                            onEnd(.left)
                        } else {
                            xOffset = 0
                        }
                    case .down:
                        if yOffset > swipeVTrigger {
                            yOffset = screenHeight
                            onEnd(.down)
                        } else {
                            yOffset = 0
                        }
                    case .up:
                        if yOffset < -swipeVTrigger {
                            yOffset = -screenHeight
                            onEnd(.up)
                        } else {
                            yOffset = 0
                        }
                    case .none:
                        break
                    }
                }
            )
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            viewSize = proxy.size
                        }
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

#Preview(body: {
    ZStack {
        ForEach(0 ..< 10, id: \.self) { _ in
            Rectangle()
                .fill(.orange)
                .shadow(radius: 5)
                .frame(width: 100, height: 100)
                .cardAnimation { direction in
                    print(direction)
                }
        }
    }
})

//
//  CardAnimation.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/12/2023.
//

import SwiftUI

struct CardAnimation: ViewModifier {
    @State var xOffset: CGFloat = .zero
    @State var viewSize: CGSize = .zero
    let screenWidth = UIScreen.main.bounds.width
    var swipeTrigger: CGFloat { viewSize.width * 1.25 }
    
    let onChange: () -> Void
    let onEnd: () -> Void
    let minimumDistance: CGFloat = 10
    let coordinateSpace: CoordinateSpace = .global
    
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .offset(x: xOffset)
            .animation(.default, value: xOffset)
            .simultaneousGesture(
                DragGesture(minimumDistance: minimumDistance,
                            coordinateSpace: coordinateSpace)
                .onChanged { value in
                    xOffset = value.translation.width
                }
                .onEnded { value in
                    switch value.direction {
                    case .right:
                        xOffset = xOffset > swipeTrigger ? screenWidth : 0
                    case .left:
                        xOffset = xOffset < -swipeTrigger ? -screenWidth : 0
                    case .down, .up, .none:
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
    func cardAnimation() -> some View {
        modifier(CardAnimation(onChange: {}, onEnd: {}))
    }
}

#Preview(body: {
    ZStack {
        ForEach(0 ..< 10, id: \.self) { _ in
            Rectangle()
                .fill(.orange)
                .shadow(radius: 5)
                .frame(width: 100, height: 100)
                .cardAnimation()
        }
    }
})

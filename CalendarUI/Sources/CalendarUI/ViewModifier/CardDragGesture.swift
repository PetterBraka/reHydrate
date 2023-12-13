//
//  CardDragGesture.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/12/2023.
//

import SwiftUI

struct CardDragGesture: ViewModifier {
    @State private var xOffset: CGFloat = .zero
    @State private var view: CGSize = .zero
    private let screen = UIScreen.main.bounds
    
    private var hChangeTrigger: CGFloat { 10 }
    private var hEndTrigger: CGFloat { view.width / 2 }

    private let minimumDistance: CGFloat
    private let coordinateSpace: CoordinateSpace

    @State private var lastChange: SwipeDirection?
    private let onChange: (SwipeDirection) -> Void
    private let onEnd: (SwipeDirection) -> Void
    
    init(minimumDistance: CGFloat,
         coordinateSpace: CoordinateSpace,
         onChange: @escaping (SwipeDirection) -> Void,
         onEnd: @escaping (SwipeDirection) -> Void) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = coordinateSpace
        self.onChange = onChange
        self.onEnd = onEnd
    }
    
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .offset(x: xOffset)
            .animation(.default, value: xOffset)
            .onAppear(update: $view)
            .simultaneousGesture(
                DragGesture(minimumDistance: minimumDistance,
                            coordinateSpace: coordinateSpace)
                .onChanged { value in
                    xOffset = value.translation.width
                    var direction: SwipeDirection? = nil
                    if xOffset > hChangeTrigger {
                        direction = .right
                    } else if xOffset < -hChangeTrigger {
                        direction = .left
                    }
                    if let direction, lastChange != direction {
                        lastChange = direction
                        onChange(direction)
                    }
                }
                .onEnded { value in
                    lastChange = nil
                    if xOffset > hEndTrigger {
                        xOffset = screen.width
                        onEnd(.right)
                    } else if xOffset < -hEndTrigger {
                        xOffset = -screen.width
                        onEnd(.left)
                    } else {
                        xOffset = 0
                    }
                }
            )
    }
}

extension View {
    func cardDragGesture(
        minimumDistance: CGFloat = 10,
        coordinateSpace: CoordinateSpace = .global,
        onChange: @escaping (SwipeDirection) -> Void,
        onEnd: @escaping (SwipeDirection) -> Void
    ) -> some View {
        modifier(CardDragGesture(
            minimumDistance: minimumDistance,
            coordinateSpace: coordinateSpace,
            onChange: onChange,
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
                .cardDragGesture { direction in
                    print("\(direction) swipe")
                } onEnd: { direction in
                    print("Ended \(direction) swipe")
                }
        }
    }
}

//
//  CardDragGesture.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/12/2023.
//

import SwiftUI

struct DragGestureViewModifier: ViewModifier {
    @State private var xOffset: CGFloat = .zero
    @State private var yOffset: CGFloat = .zero
    @State private var view: CGSize = .zero
    private let screen = UIScreen.main.bounds
    
    private var changeTrigger: CGFloat { 10 }
    private var endTrigger: CGFloat { view.width / 4 }

    private let minimumDistance: CGFloat
    private let coordinateSpace: CoordinateSpace
    private let supportedDirection: [Direction]
    
    @State private var lastChange: Direction?
    private let onChange: (Direction) -> Void
    private let onEnd: (Direction) -> Void
    
    init(minimumDistance: CGFloat,
         coordinateSpace: CoordinateSpace,
         supportedDirection: [Direction],
         onChange: @escaping (Direction) -> Void,
         onEnd: @escaping (Direction) -> Void) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = coordinateSpace
        self.supportedDirection = supportedDirection
        self.onChange = onChange
        self.onEnd = onEnd
    }
    
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .offset(x: xOffset, y: yOffset)
            .animation(.linear, value: xOffset)
            .onAppear(update: $view)
            .simultaneousGesture(
                DragGesture(minimumDistance: minimumDistance,
                            coordinateSpace: coordinateSpace)
                .onChanged { value in
                    var direction: Direction? = nil
                    if supportedDirection.contains([.left, .right]) {
                        xOffset = value.translation.width
                        if xOffset > changeTrigger {
                            direction = .right
                        } else if xOffset < -changeTrigger {
                            direction = .left
                        }
                    }
                    if supportedDirection.contains([.up, .down]) {
                        yOffset = value.translation.height
                        if yOffset > changeTrigger {
                            direction = .down
                        } else if yOffset < -changeTrigger {
                            direction = .up
                        }
                    }
                    if let direction, lastChange != direction {
                        lastChange = direction
                        onChange(direction)
                    }
                }
                .onEnded { value in
                    lastChange = nil
                    if supportedDirection.contains([.left, .right]) {
                        if xOffset > endTrigger {
                            xOffset = screen.width
                            onEnd(.right)
                        } else if xOffset < -endTrigger {
                             xOffset = -screen.width
                            onEnd(.left)
                        } else {
                            xOffset = 0
                        }
                    }
                    if supportedDirection.contains([.up, .down]) {
                        if yOffset > endTrigger {
                            yOffset = screen.height
                            onEnd(.down)
                        } else if yOffset < -endTrigger {
                             yOffset = -screen.height
                            onEnd(.up)
                        } else {
                            yOffset = 0
                        }
                    }
                }
            )
    }
}

extension View {
    func dragGesture(
        minimumDistance: CGFloat = 10,
        coordinateSpace: CoordinateSpace = .global,
        directions: [Direction],
        onChange: @escaping (Direction) -> Void,
        onEnd: @escaping (Direction) -> Void
    ) -> some View {
        modifier(DragGestureViewModifier(
            minimumDistance: minimumDistance,
            coordinateSpace: coordinateSpace,
            supportedDirection: directions,
            onChange: onChange,
            onEnd: onEnd))
    }
}

#Preview {
    RoundedRectangle(cornerRadius: 25)
        .fill(.orange)
        .shadow(radius: 5)
        .aspectRatio(1, contentMode: .fit)
        .frame(width: 200)
        .dragGesture(directions: Direction.allCases) { direction in
            print("\(direction) swipe")
        } onEnd: { direction in
            print("Ended \(direction) swipe")
        }
}

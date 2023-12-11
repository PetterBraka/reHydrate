//
//  DragGesture+Ext.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/12/2023.
//

import SwiftUI

extension DragGesture.Value {
    var direction: SwipeDirection? {
        if startLocation.x < location.x - 24 {
            return .right
        }
        if startLocation.x > location.x + 24 {
            return .left
        }
        if startLocation.y < location.y - 24 {
            return .down
        }
        if startLocation.y > location.y + 24 {
            return .up
        }
        return nil
    }
}

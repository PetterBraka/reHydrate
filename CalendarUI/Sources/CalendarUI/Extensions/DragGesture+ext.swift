//
//  DragGesture+Ext.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/12/2023.
//

import SwiftUI

extension DragGesture.Value {
    var direction: Direction? {
        if startLocation.x < location.x - 5 {
            return .right
        }
        if startLocation.x > location.x + 5 {
            return .left
        }
        if startLocation.y < location.y - 5 {
            return .down
        }
        if startLocation.y > location.y + 5 {
            return .up
        }
        return nil
    }
}

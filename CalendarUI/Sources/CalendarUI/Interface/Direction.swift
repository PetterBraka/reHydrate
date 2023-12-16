//
//  Direction.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/12/2023.
//

import SwiftUI

enum Direction: String, CaseIterable {
    case left, right, up, down
    
    var edge: Edge {
        switch self {
        case .left:
            .leading
        case .right:
            .trailing
        case .up:
            .top
        case .down:
            .bottom
        }
    }
}

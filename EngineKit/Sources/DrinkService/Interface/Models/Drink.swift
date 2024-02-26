//
//  Drink.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation

public struct Drink: Identifiable {
    public let id: String
    
    public let container: Container
    public var size: Double
    
    public init(id: String,
                size: Double,
                container: Container) {
        self.id = id
        self.container = container
        self.size = size
    }
}

//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import Blackbird

public struct DrinkModel: BlackbirdModel {
    public static var primaryKey: [BlackbirdColumnKeyPath] = [\.$container]
    
    @BlackbirdColumn public var id: String
    @BlackbirdColumn public var container: String
    @BlackbirdColumn public var size: Double
    
    public init(id: String,
                size: Double,
                container: String) {
        self.id = id
        self.container = container
        self.size = size
    }
}

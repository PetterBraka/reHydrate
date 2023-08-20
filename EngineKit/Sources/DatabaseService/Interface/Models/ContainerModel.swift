//
//  ContainerModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird

public struct ContainerModel: BlackbirdModel {
    public static var primaryKey: [BlackbirdColumnKeyPath] = [\.$size]
    
    @BlackbirdColumn public var id: String
    @BlackbirdColumn public var size: Double
    
    public init(id: String, size: Double) {
        self.id = id
        self.size = size
    }
}

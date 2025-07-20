//
//  DrinkEntity.swift
//  DBKit
//
//  Created by Petter vang Brakalsvålet on 20/07/2025.
//

import SwiftData
import DBKitInterface

@Model
public class DrinkEntity: Equatable {
    public var id: String
    public var container: String
    public var size: Double
    
    public init(id: String,
                size: Double,
                container: String) {
        self.id = id
        self.container = container
        self.size = size
    }
    
    public var asModel: DrinkModel {
        DrinkModel(id: id, size: size, container: container)
    }
}

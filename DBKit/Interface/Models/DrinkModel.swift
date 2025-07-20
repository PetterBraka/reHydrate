//
//  DrinkModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import SwiftData

@Model
public class DrinkModel: Equatable, @unchecked Sendable {
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
}

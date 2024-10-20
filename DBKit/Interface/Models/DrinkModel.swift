//
//  DrinkModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

public struct DrinkModel: Equatable, Sendable {
    public let id: String
    public let container: String
    public let size: Double
    
    public init(id: String,
                size: Double,
                container: String) {
        self.id = id
        self.container = container
        self.size = size
    }
}

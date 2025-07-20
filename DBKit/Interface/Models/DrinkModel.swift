//
//  DrinkModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

public struct DrinkModel: Equatable, Sendable {
    public var id: String
    public var size: Double
    public var container: String
    
    public init(id: String, size: Double, container: String) {
        self.id = id
        self.size = size
        self.container = container
    }
}

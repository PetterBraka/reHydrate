//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//

public protocol DomainMappable {
    associatedtype DomainModel
    func toDomainModel() throws -> DomainModel
    func update(with item: DomainModel)
}

public enum MappingError: Error {
    case proppertyWasNil
}

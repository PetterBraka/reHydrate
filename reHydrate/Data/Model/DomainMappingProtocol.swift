//
//  DomainMappingProtocol.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

protocol DomainMappable {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
    func updateCoreDataModel(_ model: DomainModelType)
}

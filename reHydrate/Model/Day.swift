//
//  Day.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

struct Day {
    let id: UUID
    var consumption: Double
    var goal: Double
    let date: Date?
}

protocol DomainMappable {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
    func updateCoreDataModel(_ model: DomainModelType)
}

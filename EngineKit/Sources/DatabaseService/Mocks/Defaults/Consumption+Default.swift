//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import DatabaseServiceInterface

extension ConsumptionModel {
    static let `default` = ConsumptionModel(id: "---", date: "---", time: "---", consumed: -999)
}

extension Array where Element == ConsumptionModel {
    static let `default` = [ConsumptionModel.default]
}

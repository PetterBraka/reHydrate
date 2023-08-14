//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import DatabaseServiceInterface

extension Consumption {
    static let `default` = Consumption(id: "---", date: "---", time: "---", consumed: -999)
}

extension Array where Element == Consumption {
    static let `default` = [Consumption.default]
}

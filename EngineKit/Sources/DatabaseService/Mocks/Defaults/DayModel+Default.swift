//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import DatabaseServiceInterface

extension DayModel {
    static let `default` = DayModel(id: "---", date: "---", consumed: -999, goal: -999)
}

extension Array where Element == DayModel {
    static let `default` = [DayModel.default]
}

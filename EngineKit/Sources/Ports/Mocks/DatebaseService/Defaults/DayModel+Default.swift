//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import PortsInterface

extension DayModel {
    static let `default` = DayModel(id: "---", date: "01/01/2022", consumed: 0, goal: 0)
}

extension Array where Element == DayModel {
    static let `default` = [DayModel.default]
}

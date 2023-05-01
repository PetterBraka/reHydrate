//
//  DayProtocol.swift
//  
//
//  Created by Petter vang Brakalsvålet on 01/05/2023.
//

import Foundation

public protocol DayProtocol: Identifiable {
    var id: UUID { get }
    var consumption: Double { get set }
    var goal: Double { get set }
    var date: Date { get }
}

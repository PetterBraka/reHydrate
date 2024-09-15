//
//  ConsumptionServiceType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation
import DrinkServiceInterface

public protocol DayServiceType {
    func getToday() async -> Day
    func getSharedToday() -> Day?
    func getDays(between dates: ClosedRange<Date>) async throws -> [Day]
    func add(drink: Drink) async throws -> Double
    func remove(drink: Drink) async throws -> Double
    func increase(goal: Double) async throws -> Double
    func decrease(goal: Double) async throws -> Double
}

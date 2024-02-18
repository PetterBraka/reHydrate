//
//  DayManagerType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/07/2023.
//

import Foundation

public protocol DayManagerType {
    func createNewDay(date: Date, goal: Double) throws -> DayModel
    func add(consumed: Double, toDayAt date: Date) async throws -> DayModel
    func remove(consumed: Double, fromDayAt date: Date) async throws -> DayModel
    func add(goal: Double, toDayAt date: Date) async throws -> DayModel
    func remove(goal: Double, fromDayAt date: Date) async throws -> DayModel
    
    func delete(_ day: DayModel) async throws
    func deleteDay(at date: Date) async throws
    func deleteDays(in range: Range<Date>) async throws
    func deleteDays(in range: ClosedRange<Date>) async throws
    
    func fetch(with date: Date) async throws -> DayModel
    func fetchLast() async throws -> DayModel
    func fetch(between date: ClosedRange<Date>) async throws -> [DayModel]
    func fetchAll() async throws -> [DayModel]
}

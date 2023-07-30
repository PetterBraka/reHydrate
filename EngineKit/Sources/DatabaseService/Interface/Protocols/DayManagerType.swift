//
//  DayManagerType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/07/2023.
//

import Foundation

public protocol DayManagerType: DbManagerType {
    func createNewDay(date: Date, goal: Double) async throws -> DayModel
    func update(consumed: Double, forDayAt date: Date) async throws
    func delete(_ day: DayModel) async throws
    func deleteDay(at date: Date) async throws
    func deleteDays(in range: Range<Date>) async throws
    func deleteDays(in range: ClosedRange<Date>) async throws
    func fetchAll() async throws -> [DayModel]
    func fetch(with date: Date) async throws -> DayModel
    func fetchLast() async throws -> DayModel?
}

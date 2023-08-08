//
//  DayDbManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird
import DatabaseServiceInterface
import Foundation

public final class DayManager: DayManagerType {
    private let database: DatabaseType
    
    public init(database: DatabaseType) {
        self.database = database
    }
    
    public func createNewDay(date: Date, goal: Double) async throws -> DayModel {
        let newDay = DayModel(id: UUID().uuidString,
                              date: date.toDateString(),
                              consumed: 0,
                              goal: goal)
        try await database.write(newDay)
        return newDay
    }
    
    public func update(consumed: Double, forDayAt date: Date) async throws {
        var dayToUpdate = try await fetch(with: date)
        dayToUpdate.consumed = consumed
        try await database.write(dayToUpdate)
    }
    
    public func delete(_ day: DayModel) async throws {
        try await database.delete(day)
    }
    
    public func deleteDay(at date: Date) async throws {
        try await database.delete(matching: .like(\DayModel.$date, date.toDateString()))
    }
    
    public func deleteDays(in range: Range<Date>) async throws {
        let dayInSeconds: TimeInterval = 60*60*24
        for date in stride(from: range.lowerBound,
                           to: range.upperBound - dayInSeconds,
                           by: dayInSeconds) {
            try await database.delete(matching: .like(\DayModel.$date, date.toDateString()))
        }
    }
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {
        let dayInSeconds: TimeInterval = 60*60*24
        for date in stride(from: range.lowerBound,
                           to: range.upperBound,
                           by: dayInSeconds) {
            try await database.delete(matching: .like(\DayModel.$date, date.toDateString()))
        }
    }
    
    public func fetch(with date: Date) async throws -> DayModel {
        let days = try await database.read(matching: .like(\DayModel.$date, date.toDateString()),
                                           orderBy: .ascending(\.$date),
                                           limit: 1)
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return day
    }
    
    public func fetchLast() async throws -> DayModel {
        let days = try await database.read(matching: nil, orderBy: .descending(\DayModel.$date), limit: 1)
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return day
    }
    
    public func fetchAll() async throws -> [DayModel] {
        let days = try await database.read(matching: nil, orderBy: .ascending(\DayModel.$date), limit: nil)
        return days
    }
}

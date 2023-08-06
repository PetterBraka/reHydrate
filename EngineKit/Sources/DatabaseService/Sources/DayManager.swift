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
                              date: date.toString(),
                              consumed: 0,
                              goal: goal)
        let db = try database.openDb()
        try await newDay.write(to: db)
        await database.close(db)
        return newDay
    }
    
    public func update(consumed: Double, forDayAt date: Date) async throws {
        var dayToUpdate = try await fetch(with: date)
        dayToUpdate.consumed = consumed
        let db = try database.openDb()
        try await dayToUpdate.write(to: db)
        await database.close(db)
    }
    
    public func delete(_ day: DayModel) async throws {
        let db = try database.openDb()
        try await day.delete(from: db)
        await database.close(db)
    }
    
    public func deleteDay(at date: Date) async throws {
        let db = try database.openDb()
        try await DayModel.delete(from: db, matching: .like(\.$date, date.toString()))
        await database.close(db)
    }
    
    public func deleteDays(in range: Range<Date>) async throws {
        let db = try database.openDb()
        let dayInSeconds: TimeInterval = 60*60*24
        for date in stride(from: range.lowerBound,
                           to: range.upperBound - dayInSeconds,
                           by: dayInSeconds) {
            try await DayModel.delete(from: db, matching: .like(\.$date, date.toString()))
        }
        await database.close(db)
    }
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {
        let db = try database.openDb()
        let dayInSeconds: TimeInterval = 60*60*24
        for date in stride(from: range.lowerBound,
                           to: range.upperBound,
                           by: dayInSeconds) {
            try await DayModel.delete(from: db, matching: .like(\.$date, date.toString()))
        }
        await database.close(db)
    }
    
    public func fetchAll() async throws -> [DayModel] {
        let db = try database.openDb()
        let days = try await DayModel.read(from: db, orderBy: .ascending(\.$date))
        await database.close(db)
        return days
    }
    
    public func fetch(with date: Date) async throws -> DayModel {
        let db = try database.openDb()
        guard let foundDay = try await DayModel.read(from: db,
                                                     matching: .like(\.$date, date.toString()),
                                                     orderBy: .ascending(\.$date),
                                                     limit: 1).first
        else {
            await database.close(db)
            throw DatabaseError.noElementFound
        }
        await database.close(db)
        return foundDay
    }
    
    public func fetchLast() async throws -> DayModel {
        let db = try database.openDb()
        guard let foundDay = try await DayModel.read(from: db, orderBy: .descending(\.$date), limit: 1).first
        else {
            await database.close(db)
            throw DatabaseError.noElementFound
        }
        await database.close(db)
        return foundDay
    }
}

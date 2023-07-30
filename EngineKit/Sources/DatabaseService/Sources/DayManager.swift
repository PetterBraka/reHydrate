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
    let db: Blackbird.Database
    
    public init(database: DatabaseType) {
        self.db = database.db
    }
    
    public func createNewDay(date: Date, goal: Double) async throws -> DayModel {
        let newDay = DayModel(id: UUID().uuidString,
                              date: date.toString(),
                              consumed: 0,
                              goal: goal)
        try await newDay.write(to: db)
        return newDay
    }
    
    public func update(consumed: Double, forDayAt date: Date) async throws {
        var dayToUpdate = try await fetch(with: date)
        dayToUpdate.consumed = consumed
        try await dayToUpdate.write(to: db)
    }
    
    public func delete(_ day: DayModel) async throws {
        try await day.delete(from: db)
    }
    
    public func deleteDay(at date: Date) async throws {
        try await DayModel.delete(from: db, matching: .like(\.$date, date.toString()))
    }
    
    public func deleteDays(in range: Range<Date>) async throws {
        let dayInSeconds: TimeInterval = 60*60*24
        for date in stride(from: range.lowerBound,
                           to: range.upperBound - dayInSeconds,
                           by: dayInSeconds) {
            try await DayModel.delete(from: db, matching: .like(\.$date, date.toString()))
        }
    }
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {
        let dayInSeconds: TimeInterval = 60*60*24
        for date in stride(from: range.lowerBound,
                           to: range.upperBound,
                           by: dayInSeconds) {
            try await DayModel.delete(from: db, matching: .like(\.$date, date.toString()))
        }
    }
    
    public func fetchAll() async throws -> [DayModel] {
        try await DayModel.read(from: db, orderBy: .ascending(\.$date))
    }
    
    public func fetch(with date: Date) async throws -> DayModel {
        guard let foundDay = try await DayModel.read(from: db,
                                                     matching: .like(\.$date, date.toString()),
                                                     orderBy: .ascending(\.$date),
                                                     limit: 1).first
        else {
            throw DatabaseError.noElementFound
        }
        return foundDay
    }
    
    public func fetchLast() async throws -> DayModel? {
        guard let foundDay = try await DayModel.read(from: db, orderBy: .descending(\.$date), limit: 1).first
        else {
            throw DatabaseError.noElementFound
        }
        return foundDay
    }
}

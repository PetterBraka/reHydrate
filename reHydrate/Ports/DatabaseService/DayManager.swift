//
//  DayDbManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Foundation
import Blackbird
import PortsInterface

public final class DayManager: DayManagerType {
    public typealias PortModel = PortsInterface.DayModel
    private let database: DatabaseType
    
    public init(database: DatabaseType) {
        self.database = database
    }
    
    public func createNewDay(date: Date, goal: Double) async throws -> PortModel {
        let newDay = DayModel(id: UUID().uuidString,
                           date: DatabaseFormatter.date.string(from: date),
                           consumed: 0,
                           goal: goal)
        try await database.write(newDay)
        return .init(from: newDay)
    }
    
    public func add(consumed: Double, toDayAt date: Date) async throws -> PortModel {
        var dayToUpdate = try await fetch(with: date)
        dayToUpdate.consumed += consumed
        try await database.write(DayModel(from: dayToUpdate))
        return dayToUpdate
    }
    
    public func remove(consumed: Double, fromDayAt date: Date) async throws -> PortModel {
        var dayToUpdate = try await fetch(with: date)
        dayToUpdate.consumed -= consumed
        if dayToUpdate.consumed < 0 {
            dayToUpdate.consumed = 0
        }
        try await database.write(DayModel(from: dayToUpdate))
        return dayToUpdate
    }
    
    public func add(goal: Double, toDayAt date: Date) async throws -> PortModel {
        var dayToUpdate = try await fetch(with: date)
        dayToUpdate.goal += goal
        try await database.write(DayModel(from: dayToUpdate))
        return dayToUpdate
    }
    
    public func remove(goal: Double, fromDayAt date: Date) async throws -> PortModel {
        var dayToUpdate = try await fetch(with: date)
        dayToUpdate.goal -= goal
        if dayToUpdate.goal < 0 {
            dayToUpdate.goal = 0
        }
        try await database.write(DayModel(from: dayToUpdate))
        return dayToUpdate
    }
    
    public func delete(_ day: PortModel) async throws {
        try await database.delete(DayModel(from: day))
    }
    
    public func deleteDay(at date: Date) async throws {
        try await database.delete(matching: .like(\DayModel.$date, DatabaseFormatter.date.string(from: date)))
    }
    
    public func deleteDays(in range: Range<Date>) async throws {
        let dayInSeconds: TimeInterval = 60*60*24
        for date in stride(from: range.lowerBound,
                           to: range.upperBound - dayInSeconds,
                           by: dayInSeconds) {
            try await database.delete(matching: .like(\DayModel.$date,  DatabaseFormatter.date.string(from: date)))
        }
    }
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {
        let dayInSeconds: TimeInterval = 60*60*24
        for date in stride(from: range.lowerBound,
                           to: range.upperBound,
                           by: dayInSeconds) {
            try await database.delete(matching: .like(\DayModel.$date,  DatabaseFormatter.date.string(from: date)))
        }
    }
    
    public func fetch(with date: Date) async throws -> PortModel {
        let days = try await database.read(matching: .like(\DayModel.$date,  DatabaseFormatter.date.string(from: date)),
                                           orderBy: .ascending(\.$date),
                                           limit: 1)
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return PortModel(from: day)
    }
    
    public func fetchLast() async throws -> PortModel {
        let days = try await database.read(matching: nil, orderBy: .descending(\DayModel.$date), limit: 1)
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return PortModel(from: day)
    }
    
    public func fetchAll() async throws -> [PortModel] {
        let days = try await database.read(matching: nil, orderBy: .ascending(\DayModel.$date), limit: nil)
        return days.map { PortModel(from: $0) }
    }
}

extension DayManager {
    public struct DayModel: BlackbirdModel {
        public static var primaryKey: [BlackbirdColumnKeyPath] = [\.$date]
        
        @BlackbirdColumn public var id: String
        @BlackbirdColumn public var date: String
        @BlackbirdColumn public var consumed: Double
        @BlackbirdColumn public var goal: Double
        
        public init(id: String, date: String,
                    consumed: Double,
                    goal: Double) {
            self.id = id
            self.date = date
            self.consumed = consumed
            self.goal = goal
        }
        
        fileprivate init(from model: PortsInterface.DayModel) {
            id = model.id
            date = model.date
            consumed = model.consumed
            goal = model.goal
        }
    }
}

private extension PortsInterface.DayModel {
    init(from model: DayManager.DayModel) {
        self.init(id: model.id, date: model.date, consumed: model.consumed, goal: model.goal)
    }
}

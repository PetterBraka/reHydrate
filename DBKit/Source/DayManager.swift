//
//  DayDbManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import SwiftData
import Foundation
import LoggingKit
import DBKitInterface

public final actor DayManager {
    nonisolated private let database: DatabaseType
    private let logger: LoggerServicing
    
    public init(database: DatabaseType, logger: LoggerServicing) {
        self.database = database
        self.logger = logger
    }
}

private extension DayManager {
    func fetchEntity(with date: Date) async throws -> DayModel {
        let dateString = DatabaseFormatter.date.string(from: date)
        let predicate = #Predicate<DayModel> { $0.date == dateString }
        let days: [DayModel] = try await database.read(
            matching: predicate,
            sortBy: [SortDescriptor(\.date, order: .forward)],
            limit: nil)
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return day
    }
    
    func fetchLastEntity() async throws -> DayModel {
        let days: [DayModel] = try await database.read(
            matching: nil,
            sortBy: [SortDescriptor(\.date, order: .reverse)],
            limit: 1)
        logger.log(category: .dayDatabase, message: "Found \(days)", error: nil, level: .debug)
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return day
    }
    
    func fetchEntities(between dates: ClosedRange<Date>) async throws -> [DayModel] {
        let allDays: [DayModel] = try await fetchAllEntities()
        let lower = DatabaseFormatter.date.string(from: dates.lowerBound)
        let upper = DatabaseFormatter.date.string(from: dates.upperBound)
        
        let filtered = allDays.filter {
            if $0.date == lower || $0.date == upper {
                return true
            }
            guard let date = DatabaseFormatter.date.date(from: $0.date) else { return false }
            return dates.contains(date)
        }
        logger.log(category: .dayDatabase, message: "Filtered \(filtered)", error: nil, level: .debug)
        return filtered
    }
    
    func fetchAllEntities() async throws -> [DayModel] {
        let days: [DayModel] = try await database.read(
            matching: nil,
            sortBy: [SortDescriptor(\.date, order: .forward)],
            limit: nil)
        logger.log(category: .dayDatabase, message: "Found \(days)", error: nil, level: .debug)
        return days
    }
}
 
extension DayManager: DayManagerType {
    public func createNewDay(date: Date, goal: Double) async throws -> DayModel {
        let newDay = DayModel(
            id: UUID().uuidString,
            date: DatabaseFormatter.date.string(from: date),
            consumed: 0,
            goal: goal
        )
        await database.insert(newDay)
        try await database.save()
        logger.log(category: .dayDatabase, message: "Created \(newDay)", error: nil, level: .debug)
        
        return newDay
    }
    
    public func add(consumed: Double, toDayAt date: Date) async throws -> DayModel {
        logger.log(category: .dayDatabase, message: "Adding \(consumed)", error: nil, level: .debug)
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.consumed += consumed
        try await database.save()
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return dayToUpdate
    }
    
    public func remove(consumed: Double, fromDayAt date: Date) async throws -> DayModel {
        logger.log(category: .dayDatabase, message: "Removing \(consumed)", error: nil, level: .debug)
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.consumed -= consumed
        if dayToUpdate.consumed < 0 {
            dayToUpdate.consumed = 0
        }
        try await database.save()
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return dayToUpdate
    }
    
    public func add(goal: Double, toDayAt date: Date) async throws -> DayModel {
        logger.log(category: .dayDatabase, message: "Removing \(goal)", error: nil, level: .debug)
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.goal += goal
        try await database.save()
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return dayToUpdate
    }
    
    public func remove(goal: Double, fromDayAt date: Date) async throws -> DayModel {
        logger.log(category: .dayDatabase, message: "Removing \(goal)", error: nil, level: .debug)
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.goal -= goal
        if dayToUpdate.goal < 0 {
            dayToUpdate.goal = 0
        }
        try await database.save()
        logger.log(category: .dayDatabase, message: "Edited \(dayToUpdate)", error: nil, level: .debug)
        return dayToUpdate
    }
    
    public func delete(_ days: [DayModel]) async throws {
        if days.allSatisfy({ $0.id.isEmpty || $0.date.isEmpty}) {
            throw DatabaseError.invalidElement
        }
        for day in days {
            await database.delete(day)
        }
        try await database.save()
        logger.log(category: .dayDatabase, message: "Deleted \(days)", error: nil, level: .debug)
    }
    
    public func deleteDay(at date: Date) async throws {
        let dayToDelete = try await fetchEntity(with: date)
        try await delete([dayToDelete])
    }
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {
        let days = try await fetchEntities(between: range)
        try await delete(days)
    }
    
    public func fetch(with date: Date) async throws -> DayModel {
        try await fetchEntity(with: date)
    }
    
    public func fetchLast() async throws -> DayModel {
        try await fetchLastEntity()
    }
    
    public func fetch(between dates: ClosedRange<Date>) async throws -> [DayModel] {
        try await fetchEntities(between: dates)
    }
    
    public func fetchAll() async throws -> [DayModel] {
        try await fetchAllEntities()
    }
}

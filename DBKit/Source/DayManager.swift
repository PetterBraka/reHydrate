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
    private let context: ModelContext
    private let logger: LoggerServicing
    
    public init(container: ModelContainer, logger: LoggerServicing) {
        self.context = ModelContext(container)
        self.logger = logger
    }
}

private extension DayManager {
    func fetchEntity(with date: Date) throws -> DayEntity {
        let dateString = DatabaseFormatter.date.string(from: date)
        let predicate = #Predicate<DayEntity> { $0.date == dateString }
        let days: [DayEntity] = try read(
            matching: predicate,
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        
        return day
    }
    
    func fetchLastEntity() throws -> DayEntity {
        let days: [DayEntity] = try read(
            sortBy: [SortDescriptor(\.date, order: .reverse)],
            limit: 1
        )
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return day
    }
    
    func fetchEntities(between dates: ClosedRange<Date>) throws -> [DayEntity] {
        let allDays: [DayEntity] = try fetchAllEntities()
        let lower = DatabaseFormatter.date.string(from: dates.lowerBound)
        let upper = DatabaseFormatter.date.string(from: dates.upperBound)
        
        let filtered = allDays.filter {
            if $0.date == lower || $0.date == upper {
                return true
            }
            guard let date = DatabaseFormatter.date.date(from: $0.date) else { return false }
            return dates.contains(date)
        }
        return filtered
    }
    
    func fetchAllEntities() throws -> [DayEntity] {
        let days: [DayEntity] = try read(sortBy: [SortDescriptor(\.date, order: .forward)])
        return days
    }
    
    func deleteModels(_ models: [DayModel]) throws {
        let entitiesToDelete = try fetchAllEntities().filter { entity in
            models.contains(where: {
                entity.date == $0.date &&
                entity.consumed == $0.consumed &&
                entity.goal == $0.goal })
        }
        try deleteEntities(entitiesToDelete)
    }
    
    func deleteEntities(_ entities: [DayEntity]) throws {
        for entity in entities {
            context.delete(entity)
        }
        try save()
    }
}
 
extension DayManager: DayManagerType {
    public func createNewDay(date: Date, goal: Double) async throws -> DayModel {
        let newDay = DayEntity(
            id: UUID().uuidString,
            date: DatabaseFormatter.date.string(from: date),
            consumed: 0,
            goal: goal
        )
        context.insert(newDay)
        try save()
        logger.log(category: .dayDatabase, message: "Created \(newDay)", error: nil, level: .debug)
        
        return newDay.asModel
    }
    
    public func add(consumed: Double, toDayAt date: Date) async throws -> DayModel {
        let dayToUpdate = try fetchEntity(with: date)
        dayToUpdate.consumed += consumed
        try save()
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return dayToUpdate.asModel
    }
    
    public func remove(consumed: Double, fromDayAt date: Date) async throws -> DayModel {
        let dayToUpdate = try fetchEntity(with: date)
        dayToUpdate.consumed -= consumed
        if dayToUpdate.consumed < 0 {
            dayToUpdate.consumed = 0
        }
        try save()
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return dayToUpdate.asModel
    }
    
    public func add(goal: Double, toDayAt date: Date) async throws -> DayModel {
        let dayToUpdate = try fetchEntity(with: date)
        dayToUpdate.goal += goal
        try save()
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return dayToUpdate.asModel
    }
    
    public func remove(goal: Double, fromDayAt date: Date) async throws -> DayModel {
        let dayToUpdate = try fetchEntity(with: date)
        dayToUpdate.goal -= goal
        if dayToUpdate.goal < 0 {
            dayToUpdate.goal = 0
        }
        try save()
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return dayToUpdate.asModel
    }
    
    public func delete(_ days: [DayModel]) async throws {
        if days.allSatisfy({ $0.id.isEmpty || $0.date.isEmpty}) {
            throw DatabaseError.invalidElement
        }
        try deleteModels(days)
        logger.log(category: .dayDatabase, message: "Deleted \(days)", error: nil, level: .debug)
    }
    
    public func deleteDay(at date: Date) async throws {
        let dayToDelete = try fetchEntity(with: date)
        try deleteEntities([dayToDelete])
        logger.log(category: .dayDatabase, message: "Deleted \(dayToDelete)", error: nil, level: .debug)
        try save()
    }
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {
        let days = try fetchEntities(between: range)
        logger.log(category: .dayDatabase, message: "Deleted \(days)", error: nil, level: .debug)
        try deleteEntities(days)
    }
    
    public func fetch(with date: Date) async throws -> DayModel {
        let day = try fetchEntity(with: date)
        logger.log(category: .dayDatabase, message: "Found \(day)", error: nil, level: .debug)
        return day.asModel
    }
    
    public func fetchLast() async throws -> DayModel {
        let day = try fetchLastEntity()
        logger.log(category: .dayDatabase, message: "Found \(day)", error: nil, level: .debug)
        return day.asModel
    }
    
    public func fetch(between dates: ClosedRange<Date>) async throws -> [DayModel] {
        let days = try fetchEntities(between: dates)
        logger.log(category: .dayDatabase, message: "Found \(days)", error: nil, level: .debug)
        return days.map { $0.asModel }
    }
    
    public func fetchAll() async throws -> [DayModel] {
        let days = try fetchAllEntities()
        logger.log(category: .dayDatabase, message: "Found \(days)", error: nil, level: .debug)
        return days.map { $0.asModel }
    }
}

private extension DayManager {
    func read<Element: PersistentModel>(
        matching: Predicate<Element>? = nil,
        sortBy: [SortDescriptor<Element>] = [],
        limit: Int? = nil
    ) throws -> [Element] {
        let fetchDescriptor = FetchDescriptor<Element>(predicate: matching, sortBy: sortBy)
        var results = try context.fetch(fetchDescriptor)
        if let limit {
            results = Array(results.prefix(limit))
        }
        return results
    }
    
    func save() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            logger.log(category: .dayDatabase, message: "Failed to save the context", error: error, level: .debug)
            throw error
        }
    }
}


//
//  DayDbManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import CoreData
import LoggingKit
import DBKitInterface

public final class DayManager {
    private let database: DatabaseType
    private let context: NSManagedObjectContext
    private let logger: LoggerServicing
    
    public init(database: DatabaseType, logger: LoggerServicing) {
        self.database = database
        self.context = database.open()
        self.logger = logger
    }
}

private extension DayManager {
    func fetchEntity(with date: Date) async throws -> DayEntity {
        let predicate = NSPredicate(format: "date == %@", DatabaseFormatter.date.string(from: date))
        
        let days: [DayEntity] = try await database.read(
            matching: predicate,
            sortBy: [.init(key: "date", ascending: true)],
            limit: nil,
            context)
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return day
    }
    
    func fetchLastEntity() async throws -> DayEntity {
        let days: [DayEntity] = try await database.read(
            matching: nil,
            sortBy: [.init(key: "date", ascending: false)],
            limit: 1,
            context)
        logger.log(category: .dayDatabase, message: "Found \(days)", error: nil, level: .debug)
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return day
    }
    
    func fetchEntities(between dates: ClosedRange<Date>) async throws -> [DayEntity] {
        let days: [DayEntity] = try await fetchAllEntities()
            .filter { day in
                guard let dateString = day.date,
                      let date = DatabaseFormatter.date.date(from: dateString)
                else { return false }
                let lowerString = DatabaseFormatter.date.string(from: dates.lowerBound)
                return lowerString == dateString ||
                dates.contains(date)
            }
        logger.log(category: .dayDatabase, message: "Found \(days)", error: nil, level: .debug)
        return days
    }
    
    func fetchAllEntities() async throws -> [DayEntity] {
        let days: [DayEntity] = try await database.read(
            matching: nil,
            sortBy: [.init(key: "date", ascending: true)],
            limit: nil,
            context
        )
        logger.log(category: .dayDatabase, message: "Found \(days)", error: nil, level: .debug)
        return days
    }
}
 
extension DayManager: DayManagerType {
    public func createNewDay(date: Date, goal: Double) throws -> DayModel {
        let newDay = DayEntity(context: context)
        newDay.id = UUID().uuidString
        newDay.date = DatabaseFormatter.date.string(from: date)
        newDay.consumed = 0
        newDay.goal = goal
        try database.save(context)
        logger.log(category: .dayDatabase, message: "Created \(newDay)", error: nil, level: .debug)
        
        return DayModel(from: newDay)
    }
    
    public func add(consumed: Double, toDayAt date: Date) async throws -> DayModel {
        logger.log(category: .dayDatabase, message: "Adding \(consumed)", error: nil, level: .debug)
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.consumed += consumed
        try database.save(context)
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return DayModel(from: dayToUpdate)
    }
    
    public func remove(consumed: Double, fromDayAt date: Date) async throws -> DayModel {
        logger.log(category: .dayDatabase, message: "Removing \(consumed)", error: nil, level: .debug)
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.consumed -= consumed
        if dayToUpdate.consumed < 0 {
            dayToUpdate.consumed = 0
        }
        try database.save(context)
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return DayModel(from: dayToUpdate)
    }
    
    public func add(goal: Double, toDayAt date: Date) async throws -> DayModel {
        logger.log(category: .dayDatabase, message: "Removing \(goal)", error: nil, level: .debug)
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.goal += goal
        try database.save(context)
        logger.log(category: .dayDatabase, message: "Updated \(dayToUpdate)", error: nil, level: .debug)
        return DayModel(from: dayToUpdate)
    }
    
    public func remove(goal: Double, fromDayAt date: Date) async throws -> DayModel {
        logger.log(category: .dayDatabase, message: "Removing \(goal)", error: nil, level: .debug)
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.goal -= goal
        if dayToUpdate.goal < 0 {
            dayToUpdate.goal = 0
        }
        try database.save(context)
        logger.log(category: .dayDatabase, message: "Edited \(dayToUpdate)", error: nil, level: .debug)
        return DayModel(from: dayToUpdate)
    }
    
    private func delete(_ day: DayEntity) throws {
        context.delete(day)
        try database.save(context)
        logger.log(category: .dayDatabase, message: "Deleted \(day)", error: nil, level: .debug)
    }
    
    public func delete(_ day: DayModel) async throws {
        guard let date = DatabaseFormatter.date.date(from: day.date)
        else {
            throw DatabaseError.deletingElement
        }
        let dayToDelete = try await fetchEntity(with: date)
        try delete(dayToDelete)
    }
    
    public func deleteDay(at date: Date) async throws {
        let dayToDelete = try await fetchEntity(with: date)
        try delete(dayToDelete)
    }
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {
        let days = try await fetchEntities(between: range)
        for day in days {
            try delete(day)
        }
    }
    
    public func fetch(with date: Date) async throws -> DayModel {
        let day = try await fetchEntity(with: date)
        return DayModel(from: day)
    }
    
    public func fetchLast() async throws -> DayModel {
        let day = try await fetchLastEntity()
        return DayModel(from: day)
    }
    
    public func fetch(between dates: ClosedRange<Date>) async throws -> [DayModel] {
        try await fetchEntities(between: dates)
            .compactMap { .init(from: $0) }
    }
    
    
    public func fetchAll() async throws -> [DayModel] {
        try await fetchAllEntities().compactMap { .init(from: $0) }
    }
}

package extension DayModel {
    init(from model: DayEntity) {
        self.init(
            id: model.id ?? UUID().uuidString,
            date: model.date ?? "", 
            consumed: model.consumed,
            goal: model.goal
        )
    }
}

extension DayEntity {
    public override var description: String {
        "Day(" +
        "id:\(id?.suffix(12) ?? "No id"), " +
        "date:\(date ?? "No date"), " +
        "consumed:\(consumed), " +
        "goal:\(goal))"
    }
}

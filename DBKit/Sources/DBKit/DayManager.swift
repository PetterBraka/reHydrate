//
//  DayDbManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import CoreData
import DBKitInterface

public final class DayManager {
    private let database: DatabaseType
    private let context: NSManagedObjectContext
    
    public init(database: DatabaseType) {
        self.database = database
        self.context = database.open()
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
        LoggingService.log(level: .debug, "Found \(days)")
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
        LoggingService.log(level: .debug, "Found \(days)")
        guard let day = days.first
        else {
            throw DatabaseError.noElementFound
        }
        return day
    }
    
    func fetchEntities(between dates: ClosedRange<Date>) async throws -> [DayEntity] {
        let lowerBound = DatabaseFormatter.date.string(from: dates.lowerBound)
        let upperBound = DatabaseFormatter.date.string(from: dates.upperBound)
        let days: [DayEntity] = try await database.read(
            matching: NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "date >= %@", lowerBound),
                NSPredicate(format: "date <= %@", upperBound)
            ]),
            sortBy: [.init(key: "date", ascending: true)],
            limit: nil,
            context
        )
        LoggingService.log(level: .debug, "Found \(days)")
        return days
    }
    
    func fetchAllEntities() async throws -> [DayEntity] {
        let days: [DayEntity] = try await database.read(
            matching: nil,
            sortBy: [.init(key: "date", ascending: true)],
            limit: nil,
            context
        )
        LoggingService.log(level: .debug, "Found \(days)")
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
        LoggingService.log(level: .debug, "Created \(newDay)")
        
        guard let newDay = DayModel(from: newDay)
        else {
            throw DatabaseError.creatingElement
        }
        return newDay
    }
    
    public func add(consumed: Double, toDayAt date: Date) async throws -> DayModel {
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.consumed += consumed
        try database.save(context)
        LoggingService.log(level: .debug, "Edited \(dayToUpdate)")
        guard let day = DayModel(from: dayToUpdate)
        else {
            throw DatabaseError.couldNotMapElement
        }
        return day
    }
    
    public func remove(consumed: Double, fromDayAt date: Date) async throws -> DayModel {
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.consumed -= consumed
        if dayToUpdate.consumed < 0 {
            dayToUpdate.consumed = 0
        }
        try database.save(context)
        LoggingService.log(level: .debug, "Edited \(dayToUpdate)")
        guard let day = DayModel(from: dayToUpdate)
        else {
            throw DatabaseError.couldNotMapElement
        }
        return day
    }
    
    public func add(goal: Double, toDayAt date: Date) async throws -> DayModel {
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.goal += goal
        try database.save(context)
        LoggingService.log(level: .debug, "Edited \(dayToUpdate)")
        guard let day = DayModel(from: dayToUpdate)
        else {
            throw DatabaseError.couldNotMapElement
        }
        return day
    }
    
    public func remove(goal: Double, fromDayAt date: Date) async throws -> DayModel {
        let dayToUpdate = try await fetchEntity(with: date)
        dayToUpdate.goal -= goal
        if dayToUpdate.goal < 0 {
            dayToUpdate.goal = 0
        }
        try database.save(context)
        LoggingService.log(level: .debug, "Edited \(dayToUpdate)")
        guard let day = DayModel(from: dayToUpdate)
        else {
            throw DatabaseError.couldNotMapElement
        }
        return day
    }
    
    private func delete(_ day: DayEntity) throws {
        context.delete(day)
        try database.save(context)
        LoggingService.log(level: .debug, "Deleted \(day)")
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
        do {
            let dayToDelete = try await fetchEntity(with: date)
            try delete(dayToDelete)
        } catch {
            throw error
        }
    }

    public func deleteDays(in range: Range<Date>) async throws {
        let days = try await fetchAllEntities()
        let filteredDays = days.filter { day in
            guard let dateString = day.date,
                  let date = DatabaseFormatter.date.date(from: dateString)
            else { return false }
            let lowerString = DatabaseFormatter.date.string(from: range.lowerBound)
            let upperString = DatabaseFormatter.date.string(from: range.upperBound)
            return lowerString == dateString ||
            range.contains(date) && upperString != dateString
        }
        for day in filteredDays {
            try delete(day)
        }
    }
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {
        let days = try await fetchAllEntities()
            .filter { day in
                guard let dateString = day.date,
                      let date = DatabaseFormatter.date.date(from: dateString)
                else { return false }
                let lowerString = DatabaseFormatter.date.string(from: range.lowerBound)
                return lowerString == dateString ||
                range.contains(date)
            }
        for day in days {
            try delete(day)
        }
    }
    
    public func fetch(with date: Date) async throws -> DayModel {
        let day = try await fetchEntity(with: date)
        guard let day = DayModel(from: day)
        else {
            throw DatabaseError.couldNotMapElement
        }
        return day
    }
    
    public func fetchLast() async throws -> DayModel {
        let day = try await fetchLastEntity()
        guard let day = DayModel(from: day)
        else {
            throw DatabaseError.noElementFound
        }
        return day
    }
    
    public func fetch(between dates: ClosedRange<Date>) async throws -> [DayModel] {
        try await fetchEntities(between: dates)
            .compactMap { .init(from: $0) }
    }
    
    
    public func fetchAll() async throws -> [DayModel] {
        try await fetchAllEntities().compactMap { .init(from: $0) }
    }
}

extension DayEntity {
    fileprivate convenience init(from model: DayModel) {
        self.init()
        id = model.id
        date = model.date
        consumed = model.consumed
        goal = model.goal
    }
}

private extension DayModel {
    init?(from model: DayEntity) {
        guard let date = model.date
        else { return nil }
        self.init(
            id: model.id ?? UUID().uuidString,
            date: date,
            consumed: model.consumed,
            goal: model.goal
        )
    }
}

extension DayEntity {
    public override var description: String {
        "Day: \n\t" +
        "id:\(id ?? "No id")\n\t" +
        "date:\(date ?? "No date")\n\t" +
        "consumed:\(consumed)\n\t" +
        "goal:\(goal)\n"
    }
}

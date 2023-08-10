//
//  ConsumptionManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

import Blackbird
import DatabaseServiceInterface
import Foundation

public final class ConsumptionManager: ConsumptionManagerType {
    private let database: DatabaseType

    public init(database: DatabaseType) {
        self.database = database
    }

    @discardableResult
    public func createEntry(
        date: Date,
        consumed: Double
    ) async throws -> Consumption {
        let newEntry = Consumption(
            id: UUID().uuidString,
            date: date.toDateString(),
            time: date.toTimeString(),
            consumed: consumed
        )
        try await database.write(newEntry)
        return newEntry
    }

    public func delete(_ entry: Consumption) async throws {
        try await database.delete(entry)
    }

    public func fetchAll(at date: Date) async throws -> [Consumption] {
        try await database.read(matching: .like(\.$date, date.toDateString()),
                      orderBy: .ascending(\.$time),
                      limit: nil)
    }
    
    public func fetchAll() async throws -> [Consumption] {
        try await database.read(matching: nil,
                                orderBy: .ascending(\Consumption.$date),
                                limit: nil)
        .sorted { lhs, rhs in
            if lhs.date == rhs.date {
                return lhs.time > rhs.time
            } else {
                return lhs.date > rhs.date
            }
        }
    }
}

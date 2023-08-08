//
//  ConsumptionTimelineManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

import Blackbird
import DatabaseServiceInterface
import Foundation

final class ConsumptionTimelineManager: ConsumptionTimelineManagerType {
    private let database: DatabaseType

    public init(database: DatabaseType) {
        self.database = database
    }

    func createEntry(
        date: Date,
        consumed: Double
    ) async throws -> ConsumptionTimelineEntry {
        let newEntry = ConsumptionTimelineEntry(
            id: UUID().uuidString,
            date: date.toDateString(),
            time: date.toTimeString(),
            consumed: consumed
        )
        try await database.write(newEntry)
        return newEntry
    }

    func delete(_ entry: ConsumptionTimelineEntry) async throws {
        try await database.delete(entry)
    }

    func fetchAll(at date: Date) async throws -> [ConsumptionTimelineEntry] {
        try await database.read(matching: .like(\.$date, date.toDateString()),
                      orderBy: .ascending(\.$time),
                      limit: nil)
    }
    
    func fetchAll() async throws -> [ConsumptionTimelineEntry] {
        try await database.read(matching: nil,
                                orderBy: .ascending(\ConsumptionTimelineEntry.$date),
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

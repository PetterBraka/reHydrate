//
//  ConsumptionManager.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

import Foundation

//public final class ConsumptionManager {
//    public struct ConsumptionModel: BlackbirdModel {
//        @BlackbirdColumn public var id: String
//        @BlackbirdColumn public var date: String
//        @BlackbirdColumn public var time: String
//        @BlackbirdColumn public var consumed: Double
//        
//        public init(id: String,
//                    date: String,
//                    time: String,
//                    consumed: Double) {
//            self.id = id
//            self.date = date
//            self.consumed = consumed
//            self.time = time
//        }
//    }
//    
//    public typealias PortModel = PortsInterface.ConsumptionModel
//    private let database: DatabaseType
//    
//    public init(database: DatabaseType) {
//        self.database = database
//    }
//
//}
//
//extension ConsumptionManager: ConsumptionManagerType {
//    @discardableResult
//    public func createEntry(
//        date: Date,
//        consumed: Double
//    ) async throws -> PortModel {
//        let newEntry = ConsumptionModel(
//            id: UUID().uuidString,
//            date: DatabaseFormatter.date.string(from: date),
//            time: DatabaseFormatter.time.string(from: date),
//            consumed: consumed
//        )
//        try await database.write(newEntry)
//        return PortModel(from: newEntry)
//    }
//
//    public func delete(_ entry: PortModel) async throws {
//        try await database.delete(ConsumptionModel(from: entry))
//    }
//
//    public func fetchAll(at date: Date) async throws -> [PortModel] {
//        try await database.read(matching: .like(\.$date, DatabaseFormatter.date.string(from: date)),
//                      orderBy: .ascending(\.$time),
//                      limit: nil)
//        .map { PortModel(from: $0) }
//    }
//    
//    public func fetchAll() async throws -> [PortModel] {
//        try await database.read(matching: nil,
//                                orderBy: .ascending(\.$date),
//                                limit: nil)
//        .sorted { lhs, rhs in
//            if lhs.date == rhs.date {
//                return lhs.time > rhs.time
//            } else {
//                return lhs.date > rhs.date
//            }
//        }
//        .map { PortModel(from: $0) }
//    }
//}
//
//private extension ConsumptionManager.ConsumptionModel {
//    init(from model: PortsInterface.ConsumptionModel) throws {
//        self.id = model.id
//        self.date = model.date
//        self.consumed = model.consumed
//        self.time = model.time
//    }
//}
//
//private extension PortsInterface.ConsumptionModel {
//    init(from model: ConsumptionManager.ConsumptionModel) {
//        self.init(id: model.id, date: model.date, time: model.time, consumed: model.consumed)
//    }
//}

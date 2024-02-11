//
//  DrinkManager.swift
//
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import Foundation

//
//public final class DrinkManager: DrinkManagerType {
//    public struct DrinkModel: BlackbirdModel {
//        public static var primaryKey: [BlackbirdColumnKeyPath] = [\.$container]
//        
//        @BlackbirdColumn public var id: String
//        @BlackbirdColumn public var container: String
//        @BlackbirdColumn public var size: Double
//        
//        public init(id: String,
//                    size: Double,
//                    container: String) {
//            self.id = id
//            self.container = container
//            self.size = size
//        }
//    }
//    
//    public typealias PortModel = PortsInterface.DrinkModel
//    private let database: DatabaseType
//    
//    public init(database: DatabaseType) {
//        self.database = database
//    }
//}
//
//extension DrinkManager {
//    public func createNewDrink(size: Double, container: String) async throws -> PortModel {
//        let newDrink = DrinkModel(id: UUID().uuidString,
//                                  size: size,
//                                  container: container)
//        try await database.write(newDrink)
//        return PortModel(from: newDrink)
//    }
//    
//    public func edit(size: Double, of container: String) async throws -> PortModel {
//        var drink = try await fetch(container)
//        drink.size = size
//        try await database.write(DrinkModel(from: drink))
//        return drink
//    }
//    
//    public func delete(_ drink: PortModel) async throws {
//        try await database.delete(DrinkModel(from: drink))
//    }
//    
//    public func deleteDrink(container: String) async throws {
//        try await database.delete(matching: .like(\DrinkModel.$container, container))
//    }
//    
//    public func deleteAll() async throws {
//        try await database.deleteAll(DrinkModel(id: "", size: 0, container: ""))
//    }
//    
//    public func fetch(_ container: String) async throws -> PortModel {
//        let drinks = try await database.read(matching: .like(\DrinkModel.$container, container),
//                                             orderBy: .ascending(\.$size),
//                                             limit: 1)
//        guard let drink = drinks.first
//        else {
//            throw DatabaseError.noElementFound
//        }
//        return PortModel(from: drink)
//    }
//    
//    public func fetchAll() async throws -> [PortModel] {
//        let drinks = try await database.read(matching: nil,
//                                             orderBy: .ascending(\DrinkModel.$size),
//                                             limit: nil)
//        return drinks.map { PortModel(from: $0)}
//    }
//}
//
//extension DrinkManager.DrinkModel {
//    fileprivate init(from model: PortsInterface.DrinkModel) throws {
//        id = model.id
//        container = model.container
//        size = model.size
//    }
//}
//
//private extension PortsInterface.DrinkModel {
//    init(from model: DrinkManager.DrinkModel) {
//        self.init(id: model.id, size: model.size, container: model.container)
//    }
//}

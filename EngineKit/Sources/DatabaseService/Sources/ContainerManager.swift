//
//  ContainerManager.swift
//
//
//  Created by Petter vang Brakalsvålet on 20/08/2023.
//

import Blackbird
import DatabaseServiceInterface
import Foundation

public final class ContainerManager: ContainerManagerType {
    private let database: DatabaseType
    
    public init(database: DatabaseType) {
        self.database = database
    }
    
    @discardableResult
    public func createEntry(of size: Int) async throws -> ContainerModel {
        let newEntry = ContainerModel(
            id: UUID().uuidString,
            size: size
        )
        try await database.write(newEntry)
        return newEntry
    }
    
    public func update(_ entry: ContainerModel, newSize: Int) async throws -> ContainerModel {
        var entry = entry
        entry.size = newSize
        try await database.write(entry)
        return entry
    }
    
    public func delete(_ entry: ContainerModel) async throws {
        try await database.delete(entry)
    }
    
    public func fetchAll() async throws -> [ContainerModel] {
        try await database.read(matching: nil,
                                orderBy: .ascending(\ContainerModel.$size),
                                limit: nil)
    }
}


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
    public func create(size: Int) async throws -> ContainerModel {
        let newEntry = ContainerModel(
            id: UUID().uuidString,
            size: size
        )
        try await database.write(newEntry)
        return newEntry
    }
    
    public func update(oldSize: Int, newSize: Int) async throws -> ContainerModel {
        guard var container = try await database.read(
            matching: .like(\ContainerModel.$size, "\(oldSize)"),
            orderBy: .ascending(\.$size),
            limit: 1
        ).first else {
            throw DatabaseError.noElementFound
        }
        container.size = newSize
        try await database.write(container)
        return container
    }
    
    public func delete(size: Int) async throws {
        try await database.delete(matching: .like(\ContainerModel.$size, "\(size)"))
    }
    
    public func fetchAll() async throws -> [ContainerModel] {
        try await database.read(matching: nil,
                                orderBy: .ascending(\ContainerModel.$size),
                                limit: nil)
    }
}


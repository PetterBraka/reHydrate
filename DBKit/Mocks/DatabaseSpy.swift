//
//  DatabaseSpy.swift
//  
//
//  Created by Petter vang Brakalsvålet on 06/08/2023.
//

import SwiftData
import Foundation
import DBKitInterface

public protocol DatabaseSpying {
    associatedtype DbModel: PersistentModel & Sendable
    associatedtype RealDatabase: DatabaseType
    func getMethodNamesLog() async -> [DatabaseSpy<DbModel, RealDatabase>.MethodName]
}

public final actor DatabaseSpy<DbModel: PersistentModel & Sendable, RealDatabase: DatabaseType> {
    public enum MethodName: Equatable, Sendable {
        case insert
        case delete
        case save
        case read
    }
    
    public private(set) var methodNameLog: [MethodName] = []
    private let realObject: RealDatabase
    
    public init(realObject: RealDatabase) {
        self.realObject = realObject
    }
}

extension DatabaseSpy: DatabaseSpying {
    public func getMethodNamesLog() async -> [MethodName] {
        methodNameLog
    }
}

extension DatabaseSpy: DatabaseType {
    public func insert<Model: PersistentModel & Sendable>(_ model: Model) async {
        methodNameLog.append(.insert)
        await realObject.insert(model)
    }
    
    public func delete<Model: PersistentModel & Sendable>(_ model: Model) async {
        methodNameLog.append(.delete)
        await realObject.delete(model)
    }
    
    public func save() async throws {
        methodNameLog.append(.save)
        try await realObject.save()
    }
    
    public func read<Element: PersistentModel & Sendable>(matching: Predicate<Element>?, sortBy: [SortDescriptor<Element>], limit: Int?) async throws -> [Element] {
        methodNameLog.append(.read)
        return try await realObject.read(matching: matching, sortBy: sortBy, limit: limit)
    }
}

//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/08/2023.
//

import Blackbird
import DatabaseServiceInterface

public protocol DatabaseStubbing {
    var readMatchingOrderByLimit_returnValue: [any BlackbirdModel] { get }
}

public final class DatabaseStub: DatabaseStubbing {
    public var readMatchingOrderByLimit_returnValue: [any BlackbirdModel] = []
    public init() {}
}

extension DatabaseStub: DatabaseType {
    public var db: Blackbird.Database? {
        try! .inMemoryDatabase()
    }
    
    public func write<Element>(
        _ element: Element
    ) async throws where Element : BlackbirdModel {}
    
    public func read<Element>(
        matching: BlackbirdModelColumnExpression<Element>?,
        orderBy: BlackbirdModelOrderClause<Element>,
        limit: Int?
    ) async throws -> [Element] where Element : BlackbirdModel {
        readMatchingOrderByLimit_returnValue as! [Element]
    }
    
    public func delete<Element>(
        _ element: Element
    ) async throws where Element : BlackbirdModel {}
    
    public func delete<Element>(
        matching: BlackbirdModelColumnExpression<Element>
    ) async throws where Element : BlackbirdModel {}
    
    public func deleteAll<Element>(
        _ element: Element
    ) async throws where Element : BlackbirdModel {}
}

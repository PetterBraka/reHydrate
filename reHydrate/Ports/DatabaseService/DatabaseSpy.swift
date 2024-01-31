//
//  DatabaseSpy.swift
//  
//
//  Created by Petter vang Brakalsvålet on 06/08/2023.
//

import Blackbird
import PortsInterface
import Foundation

public protocol DatabaseSpying {
    associatedtype DbModel: BlackbirdModel
    var varLog: [DatabaseSpy<DbModel>.VariableCall] { get set }
    var methodLog: [DatabaseSpy<DbModel>.MethodCall] { get set }
    var methodLogNames: [DatabaseSpy<DbModel>.MethodName] { get }
    var parametersForLasCallTo_write: DbModel? { get }
    var parametersForLasCallTo_read: (matching: BlackbirdModelColumnExpression<DbModel>?,
                                      orderBy: BlackbirdModelOrderClause<DbModel>,
                                      limit: Int?)? { get }
    var parametersForLasCallTo_delete: DbModel? { get }
    var parametersForLasCallTo_deleteMatching: BlackbirdModelColumnExpression<DbModel>? { get }
}

public final class DatabaseSpy<DbModel: BlackbirdModel & Equatable> {
    public enum VariableCall: Equatable {
        case db
    }
    
    public enum MethodCall {
        case write(DbModel)
        case readMatchingOrderByLimit(matching: BlackbirdModelColumnExpression<DbModel>?,
                                      orderBy: BlackbirdModelOrderClause<DbModel>,
                                      limit: Int?)
        case delete(DbModel)
        case deleteMatching(BlackbirdModelColumnExpression<DbModel>)
        case deleteAll(DbModel)
    }
    
    public enum MethodName {
        case write
        case readMatchingOrderByLimit
        case delete
        case deleteMatching
        case deleteAll
    }
    
    public var varLog: [VariableCall] = []
    public var methodLog: [MethodCall] = []
    private let realObject: DatabaseType
    
    public init(realObject: DatabaseType) {
        self.realObject = realObject
    }
}

extension DatabaseSpy: DatabaseSpying {
    public var methodLogNames: [MethodName] {
        methodLog.map { method -> MethodName in
                .init(method)
        }
    }
    
    public var parametersForLasCallTo_write: DbModel? {
        for methodCall in methodLog.reversed() {
            switch methodCall {
            case let .write(element):
                return element
            default:
                continue
            }
        }
        return nil
    }
    
    public var parametersForLasCallTo_read: (matching: BlackbirdModelColumnExpression<DbModel>?,
                                      orderBy: BlackbirdModelOrderClause<DbModel>,
                                      limit: Int?)? {
        for methodCall in methodLog.reversed() {
            switch methodCall {
            case let .readMatchingOrderByLimit(matching, orderBy, limit):
                return (matching, orderBy, limit)
            default:
                continue
            }
        }
        return nil
    }
    
    public var parametersForLasCallTo_delete: DbModel? {
        for methodCall in methodLog.reversed() {
            switch methodCall {
            case let .delete(element):
                return element
            default:
                continue
            }
        }
        return nil
    }
    
    public var parametersForLasCallTo_deleteMatching: BlackbirdModelColumnExpression<DbModel>? {
        for methodCall in methodLog.reversed() {
            switch methodCall {
            case let .deleteMatching(matching):
                return matching
            default:
                continue
            }
        }
        return nil
    }
}

extension DatabaseSpy: DatabaseType {
    public var db: Blackbird.Database? {
        varLog.append(.db)
        return realObject.db
    }
    
    public func write<Element: BlackbirdModel>(_ element: Element) async throws {
        methodLog.append(.write(element as! DbModel))
        try await realObject.write(element)
    }
    
    public func read<Element: BlackbirdModel>(
        matching: BlackbirdModelColumnExpression<Element>?,
        orderBy: BlackbirdModelOrderClause<Element>,
        limit: Int?
    ) async throws -> [Element] {
        methodLog.append(.readMatchingOrderByLimit(
            matching: matching as! BlackbirdModelColumnExpression<DbModel>?,
            orderBy: orderBy as! BlackbirdModelOrderClause<DbModel>,
            limit: limit))
        return try await realObject.read(matching: matching, orderBy: orderBy, limit: limit)
    }
    
    public func delete<Element: BlackbirdModel>(_ element: Element) async throws {
        methodLog.append(.delete(element as! DbModel))
        try await realObject.delete(element)
    }
    
    public func delete<Element: BlackbirdModel>(matching: BlackbirdModelColumnExpression<Element>) async throws {
        methodLog.append(.deleteMatching(matching as! BlackbirdModelColumnExpression<DbModel>))
        try await realObject.delete(matching: matching)
    }
    
    public func deleteAll<Element>(_ element: Element) async throws where Element : BlackbirdModel {
        methodLog.append(.deleteAll(element as! DbModel))
        try await realObject.deleteAll(element)
    }
}

extension DatabaseSpy.MethodName {
    init(_ methodCall: DatabaseSpy.MethodCall) {
        switch methodCall {
        case .write:
            self = .write
        case .readMatchingOrderByLimit:
            self = .readMatchingOrderByLimit
        case .delete:
            self = .delete
        case .deleteMatching:
            self = .deleteMatching
        case .deleteAll:
            self = .deleteAll
        }
    }
}

extension DatabaseSpy.MethodCall: Equatable {
    public static func == (lhs: DatabaseSpy.MethodCall,
                           rhs: DatabaseSpy.MethodCall) -> Bool {
        switch (lhs, rhs) {
        case let (.write(lhsElement), .write(rhsElement)):
            return lhsElement == rhsElement
        case let (.readMatchingOrderByLimit(matching: lhsMatching,
                                            orderBy: lhsOrderBy,
                                            limit: lhsLimit),
                  .readMatchingOrderByLimit(matching: rhsMatching,
                                            orderBy: rhsOrderBy,
                                            limit: rhsLimit)):
            return String(describing: lhsMatching) == String(describing: rhsMatching) &&
            String(describing: lhsOrderBy) == String(describing: rhsOrderBy) &&
            lhsLimit == rhsLimit
        case let (.delete(lhsElement), .delete(rhsElement)):
            return lhsElement == rhsElement
        case let (.deleteMatching(lhsElement), .deleteMatching(rhsElement)):
            return String(describing: lhsElement) == String(describing: rhsElement)
        case let (.deleteAll(lhsElement), .deleteAll(rhsElement)):
            return lhsElement == rhsElement
        case (.write, .readMatchingOrderByLimit),
            (.write, .delete),
            (.write, .deleteMatching),
            (.write, .deleteAll),
            (.readMatchingOrderByLimit, .write),
            (.readMatchingOrderByLimit, .delete),
            (.readMatchingOrderByLimit, .deleteMatching),
            (.readMatchingOrderByLimit, .deleteAll),
            (.delete, .write),
            (.delete, .readMatchingOrderByLimit),
            (.delete, .deleteMatching),
            (.delete, .deleteAll),
            (.deleteMatching, .write),
            (.deleteMatching, .readMatchingOrderByLimit),
            (.deleteMatching, .delete),
            (.deleteMatching, .deleteAll),
            (.deleteAll, .write),
            (.deleteAll, .readMatchingOrderByLimit),
            (.deleteAll, .delete),
            (.deleteAll, .deleteMatching):
            return false
        }
    }
}

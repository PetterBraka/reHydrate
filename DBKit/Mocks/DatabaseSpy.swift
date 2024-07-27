//
//  DatabaseSpy.swift
//  
//
//  Created by Petter vang Brakalsvålet on 06/08/2023.
//

import Foundation
import CoreData
import DBKitInterface

public protocol DatabaseSpying {
    associatedtype DbModel: NSManagedObject
    associatedtype RealDatabase: DatabaseType
    var varLog: [DatabaseSpy<DbModel, RealDatabase>.VariableCall] { get set }
    var methodLog: [DatabaseSpy<DbModel, RealDatabase>.MethodCall] { get set }
    var methodLogNames: [DatabaseSpy<DbModel, RealDatabase>.MethodName] { get }
    var parametersForLasCallTo_save: NSManagedObjectContext? { get }
    var parametersForLasCallTo_read: (matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?, context: NSManagedObjectContext)? { get }
}

public final class DatabaseSpy<DbModel: NSManagedObject & Equatable, RealDatabase: DatabaseType> {
    public enum VariableCall: Equatable {}
    
    public enum MethodCall: Equatable {
        case `open`
        case save(_ context: NSManagedObjectContext)
        case read(matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?, _ context: NSManagedObjectContext)
    }
    
    public enum MethodName: Equatable {
        case `open`
        case save
        case read
    }
    
    public var varLog: [VariableCall] = []
    public var methodLog: [MethodCall] = []
    private let realObject: RealDatabase
    
    public init(realObject: RealDatabase) {
        self.realObject = realObject
    }
}

extension DatabaseSpy: DatabaseSpying {
    public var methodLogNames: [MethodName] {
        methodLog.map { method -> MethodName in
                .init(method)
        }
    }
    
    public var parametersForLasCallTo_save: NSManagedObjectContext? {
        for methodCall in methodLog.reversed() {
            switch methodCall {
            case let .save(context):
                return context
            default:
                continue
            }
        }
        return nil
    }
    
    public var parametersForLasCallTo_read: (matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?, context: NSManagedObjectContext)? {
        for methodCall in methodLog.reversed() {
            switch methodCall {
            case let .read(matching, sortBy, limit, context):
                return (matching, sortBy, limit, context)
            default:
                continue
            }
        }
        return nil
    }
}

extension DatabaseSpy: DatabaseType {
    public func open() -> NSManagedObjectContext {
        methodLog.append(.open)
        return realObject.open()
    }
    
    public func save(_ context: NSManagedObjectContext) throws {
        methodLog.append(.save(context))
        try realObject.save(context)
    }
    
    public func read<Element: NSManagedObject>(matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?, _ context: NSManagedObjectContext) async throws -> [Element] {
        methodLog.append(.read(matching: matching, sortBy: sortBy, limit: limit, context))
        return try await realObject.read(matching: matching, sortBy: sortBy, limit: limit, context)
    }
}

extension DatabaseSpy.MethodName {
    init(_ methodCall: DatabaseSpy.MethodCall) {
        self = switch methodCall {
        case .open: .open
        case .save: .save
        case .read: .read
        }
    }
}

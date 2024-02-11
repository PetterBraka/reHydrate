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
    associatedtype RealDatabase: DatabaseType<DbModel>
    var varLog: [DatabaseSpy<DbModel, RealDatabase>.VariableCall] { get set }
    var methodLog: [DatabaseSpy<DbModel, RealDatabase>.MethodCall] { get set }
    var methodLogNames: [DatabaseSpy<DbModel, RealDatabase>.MethodName] { get }
    var parametersForLasCallTo_save: NSManagedObjectContext? { get }
    var parametersForLasCallTo_create: NSManagedObjectContext? { get}
    var parametersForLasCallTo_read: (matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?, context: NSManagedObjectContext)? { get }
    var parametersForLasCallTo_delete: (element: DbModel, context: NSManagedObjectContext)? { get }
}

public final class DatabaseSpy<DbModel: NSManagedObject & Equatable, RealDatabase: DatabaseType<DbModel>> {
    public enum VariableCall: Equatable {}
    
    public enum MethodCall: Equatable {
        case `open`
        case save(_ context: NSManagedObjectContext)
        case create(_ context: NSManagedObjectContext)
        case read(matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?, _ context: NSManagedObjectContext)
        case delete(_ element: DbModel, _ context: NSManagedObjectContext)
    }
    
    public enum MethodName: Equatable {
        case `open`
        case save
        case create
        case read
        case delete
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
    
    public var parametersForLasCallTo_create: NSManagedObjectContext? {
        for methodCall in methodLog.reversed() {
            switch methodCall {
            case let .create(context):
                return (context)
            default:
                continue
            }
        }
        return nil
    }
    
    public var parametersForLasCallTo_delete: (element: DbModel, context: NSManagedObjectContext)? {
        for methodCall in methodLog.reversed() {
            switch methodCall {
            case let .delete(element, context):
                return (element, context)
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
    
    public func save(_ context: NSManagedObjectContext) {
        methodLog.append(.save(context))
        realObject.save(context)
    }
    
    public func create(_ context: NSManagedObjectContext) throws -> DbModel {
        methodLog.append(.create(context))
        return try realObject.create(context)
    }
    
    public func read(matching: NSPredicate?, sortBy: [NSSortDescriptor]?, limit: Int?, _ context: NSManagedObjectContext) async throws -> [DbModel] {
        methodLog.append(.read(matching: matching, sortBy: sortBy, limit: limit, context))
        return try await realObject.read(matching: matching, sortBy: sortBy, limit: limit, context)
    }
    
    public func delete(_ element: DbModel, _ context: NSManagedObjectContext) throws {
        methodLog.append(.delete(element, context))
        try realObject.delete(element, context)
    }
}

extension DatabaseSpy.MethodName {
    init(_ methodCall: DatabaseSpy.MethodCall) {
        self = switch methodCall {
        case .open: .open
        case .save: .save
        case .create: .create
        case .read: .read
        case .delete: .delete
        }
    }
}

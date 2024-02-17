//
//  DayManagerStub.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import Foundation
import CoreData
import DBKitInterface

public protocol DayManagerStubbing {
    var createNewDay_returnValue: Result<DayModel, Error> { get set }
    var addConsumed_returnValue: Result<DayModel, Error> { get set }
    var removeConsumed_returnValue: Result<DayModel, Error> { get set }
    var addGoal_returnValue: Result<DayModel, Error> { get set }
    var removeGoal_returnValue: Result<DayModel, Error> { get set }
    var delete_returnError: Error? { get set }
    var deleteDay_returnError: Error? { get set }
    var deleteDays_returnError: Error? { get set }
    var fetchWithDate_returnValue: Result<DayModel, Error>{ get set }
    var fetchLast_returnValue: Result<DayModel, Error>{ get set }
    var fetchAll_returnValue: Result<[DayModel], Error> { get set }
}

public final class DayManagerStub: DayManagerStubbing {
    public init() {}
    
    public var createNewDay_returnValue: Result<DayModel, Error> = .default
    public var addConsumed_returnValue: Result<DayModel, Error> = .default
    public var removeConsumed_returnValue: Result<DayModel, Error> = .default
    public var addGoal_returnValue: Result<DayModel, Error> = .default
    public var removeGoal_returnValue: Result<DayModel, Error> = .default
    public var delete_returnError: Error?
    public var deleteDay_returnError: Error?
    public var deleteDays_returnError: Error?
    public var fetchWithDate_returnValue: Result<DayModel, Error> = .default
    public var fetchLast_returnValue: Result<DayModel, Error> = .default
    public var fetchAll_returnValue: Result<[DayModel], Error> = .default
}

extension DayManagerStub: DayManagerType {
    public func createNewDay(date: Date, goal: Double) throws -> DayModel {
        switch createNewDay_returnValue {
        case let .success(element):
            return element
        case let .failure(error):
            throw error
        }
    }
    
    public func add(consumed: Double, toDayAt date: Date) async throws -> DayModel {
        switch addConsumed_returnValue {
        case let .success(element):
            return element
        case let .failure(error):
            throw error
        }
    }
    
    public func remove(consumed: Double, fromDayAt date: Date) async throws -> DayModel {
        switch removeConsumed_returnValue {
        case let .success(element):
            return element
        case let .failure(error):
            throw error
        }
    }
    
    public func add(goal: Double, toDayAt date: Date) async throws -> DayModel {
        switch addGoal_returnValue {
        case let .success(element):
            return element
        case let .failure(error):
            throw error
        }
    }
    
    public func remove(goal: Double, fromDayAt date: Date) async throws -> DayModel {
        switch removeGoal_returnValue {
        case let .success(element):
            return element
        case let .failure(error):
            throw error
        }
    }
    
    public func delete(_ day: DayModel) async throws {
        if let delete_returnError {
            throw delete_returnError
        }
    }
    
    public func deleteDay(at date: Date) async throws {
        if let deleteDay_returnError {
            throw deleteDay_returnError
        }
    }
    
    public func deleteDays(in range: Range<Date>) async throws {
        if let deleteDays_returnError {
            throw deleteDays_returnError
        }
    }
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {
        if let deleteDays_returnError {
            throw deleteDays_returnError
        }
    }
    
    public func fetch(with date: Date) async throws -> DayModel {
        switch fetchWithDate_returnValue {
        case let .success(element):
            return element
        case let .failure(error):
            throw error
        }
    }
    
    public func fetchLast() async throws -> DayModel {
        switch fetchLast_returnValue {
        case let .success(element):
            return element
        case let .failure(error):
            throw error
        }
    }
    
    public func fetchAll() async throws -> [DayModel] {
        switch fetchAll_returnValue {
        case let .success(elements):
            return elements
        case let .failure(error):
            throw error
        }
    }
}

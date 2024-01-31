//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import PortsInterface
import Foundation

public protocol DayManagerStubbing {
    var createNewDay_returnValue: DayModel { get set }
    var createNewDay_returnError: Error? { get set }
    var addConsumed_returnValue: DayModel { get set }
    var addConsumed_returnError: Error? { get set }
    var removeConsumed_returnValue: DayModel { get set }
    var removeConsumed_returnError: Error? { get set }
    var addGoal_returnValue: DayModel { get set }
    var addGoal_returnError: Error? { get set }
    var removeGoal_returnValue: DayModel { get set }
    var removeGoal_returnError: Error? { get set }
    var delete_returnError: Error? { get set }
    var deleteDay_returnError: Error? { get set }
    var deleteDays_returnError: Error? { get set }
    var fetchWithDate_returnValue: DayModel { get set }
    var fetchWithDate_returnError: Error? { get set }
    var fetchLast_returnValue: DayModel { get set }
    var fetchLast_returnError: Error? { get set }
    var fetchAll_returnValue: [DayModel] { get set }
    var fetchAll_returnError: Error? { get set }
}

public final class DayManagerStub: DayManagerStubbing {
    public init() {}
    
    public var createNewDay_returnValue: DayModel = .default
    public var createNewDay_returnError: Error?
    public var addConsumed_returnValue: DayModel = .default
    public var addConsumed_returnError: Error?
    public var removeConsumed_returnValue: DayModel = .default
    public var removeConsumed_returnError: Error?
    public var addGoal_returnValue: DayModel = .default
    public var addGoal_returnError: Error?
    public var removeGoal_returnValue: DayModel = .default
    public var removeGoal_returnError: Error?
    public var delete_returnError: Error?
    public var deleteDay_returnError: Error?
    public var deleteDays_returnError: Error?
    public var fetchWithDate_returnValue: DayModel = .default
    public var fetchWithDate_returnError: Error?
    public var fetchLast_returnValue: DayModel = .default
    public var fetchLast_returnError: Error?
    public var fetchAll_returnValue: [DayModel] = .default
    public var fetchAll_returnError: Error?
}

extension DayManagerStub: DayManagerType {
    public func createNewDay(date: Date, goal: Double) async throws -> DayModel {
        if let createNewDay_returnError {
            throw createNewDay_returnError
        }
        return createNewDay_returnValue
    }
    
    public func add(consumed: Double, toDayAt date: Date) async throws -> DayModel {
        if let addConsumed_returnError {
            throw addConsumed_returnError
        }
        return addConsumed_returnValue
    }
    
    public func remove(consumed: Double, fromDayAt date: Date) async throws -> DayModel {
        if let removeConsumed_returnError {
            throw removeConsumed_returnError
        }
        return removeConsumed_returnValue
    }
    
    public func add(goal: Double, toDayAt date: Date) async throws -> DayModel {
        if let addGoal_returnError {
            throw addGoal_returnError
        }
        return addGoal_returnValue
    }
    
    public func remove(goal: Double, fromDayAt date: Date) async throws -> DayModel {
        if let removeGoal_returnError {
            throw removeGoal_returnError
        }
        return removeGoal_returnValue
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
        if let fetchWithDate_returnError {
            throw fetchWithDate_returnError
        }
        return fetchWithDate_returnValue
    }
    
    public func fetchLast() async throws -> DayModel {
        if let fetchLast_returnError {
            throw fetchLast_returnError
        }
        return fetchLast_returnValue
    }
    
    public func fetchAll() async throws -> [DayModel] {
        if let fetchAll_returnError {
            throw fetchAll_returnError
        }
        return fetchAll_returnValue
    }
}

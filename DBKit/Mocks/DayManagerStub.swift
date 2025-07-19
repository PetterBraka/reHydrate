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
    func set(_ response: DayManagerStub.StubResponse) async
}

public final actor DayManagerStub: DayManagerStubbing {
    public init() {}
    
    private var createNewDay_returnValue: Result<DayModel, Error> = .default
    private var addConsumed_returnValue: Result<DayModel, Error> = .default
    private var removeConsumed_returnValue: Result<DayModel, Error> = .default
    private var addGoal_returnValue: Result<DayModel, Error> = .default
    private var removeGoal_returnValue: Result<DayModel, Error> = .default
    private var delete_returnError: Error?
    private var deleteDay_returnError: Error?
    private var deleteDays_returnError: Error?
    private var fetchWithDate_returnValue: Result<DayModel, Error> = .default
    private var fetchLast_returnValue: Result<DayModel, Error> = .default
    private var fetchBetween_returnValue: Result<[DayModel], Error> = .default
    private var fetchAll_returnValue: Result<[DayModel], Error> = .default
    
    public enum StubResponse: Sendable {
        case createNewDay(Result<DayModel, Error>)
        case addConsumed(Result<DayModel, Error>)
        case removeConsumed(Result<DayModel, Error>)
        case addGoal(Result<DayModel, Error>)
        case removeGoal(Result<DayModel, Error>)
        case delete(Error?)
        case deleteDay(Error?)
        case deleteDays(Error?)
        case fetchWithDate(Result<DayModel, Error>)
        case fetchLast(Result<DayModel, Error>)
        case fetchBetween(Result<[DayModel], Error>)
        case fetchAll(Result<[DayModel], Error>)
    }

    public func set(_ response: StubResponse) async {
        switch response {
        case let .createNewDay(value):
            self.createNewDay_returnValue = value
        case let .addConsumed(value):
            self.addConsumed_returnValue = value
        case let .removeConsumed(value):
            self.removeConsumed_returnValue = value
        case let .addGoal(value):
            self.addGoal_returnValue = value
        case let .removeGoal(value):
            self.removeGoal_returnValue = value
        case let .delete(error):
            self.delete_returnError = error
        case let .deleteDay(error):
            self.deleteDay_returnError = error
        case let .deleteDays(error):
            self.deleteDays_returnError = error
        case let .fetchWithDate(value):
            self.fetchWithDate_returnValue = value
        case let .fetchLast(value):
            self.fetchLast_returnValue = value
        case let .fetchBetween(value):
            self.fetchBetween_returnValue = value
        case let .fetchAll(value):
            self.fetchAll_returnValue = value
        }
    }
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
    
    public func delete(_ day: [DayModel]) async throws {
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
    
    public func fetch(between date: ClosedRange<Date>) async throws -> [DayModel] {
        switch fetchBetween_returnValue {
        case let .success(elements):
            return elements
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

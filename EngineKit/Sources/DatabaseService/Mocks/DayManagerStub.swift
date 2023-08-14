//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import DatabaseServiceInterface
import Foundation

public protocol DayManagerStubbing {
    var createNewDay_returnValue: DayModel { get set }
    var createNewDay_returnError: Error? { get set }
    
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
    
    public func update(consumed: Double, forDayAt date: Date) async throws {}
    
    public func delete(_ day: DayModel) async throws {}
    
    public func deleteDay(at date: Date) async throws {}
    
    public func deleteDays(in range: Range<Date>) async throws {}
    
    public func deleteDays(in range: ClosedRange<Date>) async throws {}
    
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

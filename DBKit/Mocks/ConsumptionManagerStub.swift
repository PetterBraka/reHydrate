//
//  ConsumptionManagerStub.swift
//
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import Foundation
import CoreData
import DBKitInterface

public protocol ConsumptionManagerStubbing {
    func set(_ response: ConsumptionManagerStub.StubResponse) async
}

public final actor ConsumptionManagerStub: ConsumptionManagerStubbing {
    public init() {}

    private var createEntry_returnValue: Result<ConsumptionModel, Error> = .default
    private var delete_returnError: Error? = nil
    private var fetchAllAtDate_returnValue: Result<[ConsumptionModel], Error> = .default
    private var fetchAll_returnValue: Result<[ConsumptionModel], Error> = .default
    
    public enum StubResponse: Sendable {
        case createEntry(Result<ConsumptionModel, Error>)
        case delete(Error?)
        case fetchAllAtDate(Result<[ConsumptionModel], Error>)
        case fetchAll(Result<[ConsumptionModel], Error>)
    }

    public func set(_ response: StubResponse) async {
        switch response {
        case let .createEntry(result):
            createEntry_returnValue = result
        case let .delete(error):
            delete_returnError = error
        case let .fetchAllAtDate(result):
            fetchAllAtDate_returnValue = result
        case let .fetchAll(result):
            fetchAll_returnValue = result
        }
    }
}

extension ConsumptionManagerStub: ConsumptionManagerType {
    public func createEntry(date: Date, consumed: Double) throws -> ConsumptionModel {
        switch createEntry_returnValue {
        case let .success(element):
            return element
        case let .failure(error):
            throw error
        }
    }
    
    public func delete(_ entry: ConsumptionModel) async throws {
        if let delete_returnError {
            throw delete_returnError
        }
    }
    
    public func fetchAll(at date: Date) async throws -> [ConsumptionModel] {
        switch fetchAllAtDate_returnValue {
        case let .success(elements):
            return elements
        case let .failure(error):
            throw error
        }
    }
    
    public func fetchAll() async throws -> [ConsumptionModel] {
        switch fetchAll_returnValue {
        case let .success(elements):
            return elements
        case let .failure(error):
            throw error
        }
    }
}

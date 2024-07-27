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
    var createEntry_returnValue: Result<ConsumptionModel, Error> { get set }
    var delete_returnError: Error? { get set }
    var fetchAllAtDate_returnValue: Result<[ConsumptionModel], Error> { get set }
    var fetchAll_returnValue: Result<[ConsumptionModel], Error> { get set }
}

public final class ConsumptionManagerStub: ConsumptionManagerStubbing {
    public init() {}
    
    public var createEntry_returnValue: Result<ConsumptionModel, Error> = .default
    public var delete_returnError: Error? = nil
    public var fetchAllAtDate_returnValue: Result<[ConsumptionModel], Error> = .default
    public var fetchAll_returnValue: Result<[ConsumptionModel], Error> = .default
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


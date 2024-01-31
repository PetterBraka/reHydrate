//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import PortsInterface
import Foundation

public protocol ConsumptionManagerStubbing {
    var createEntry_returnValue: ConsumptionModel { get set }
    var createEntry_returnError: Error? { get set }
    
    var fetchAllAtDate_returnValue: [ConsumptionModel] { get set }
    var fetchAllAtDate_returnError: Error? { get set }
    var fetchAll_returnValue: [ConsumptionModel] { get set }
    var fetchAll_returnError: Error? { get set }
}

public final class ConsumptionManagerStub: ConsumptionManagerStubbing {
    public init() {}
    
    public var createEntry_returnValue: ConsumptionModel = .default
    public var createEntry_returnError: Error?
    public var fetchAllAtDate_returnValue: [ConsumptionModel] = .default
    public var fetchAllAtDate_returnError: Error?
    public var fetchAll_returnValue: [ConsumptionModel] = .default
    public var fetchAll_returnError: Error?
}

extension ConsumptionManagerStub: ConsumptionManagerType {
    public func createEntry(date: Date, consumed: Double) async throws -> ConsumptionModel {
        if let createEntry_returnError {
            throw createEntry_returnError
        }
        return createEntry_returnValue
    }
    
    public func delete(_ entry: Entry) async throws {}
    
    public func fetchAll(at date: Date) async throws -> [ConsumptionModel] {
        if let fetchAllAtDate_returnError {
            throw fetchAllAtDate_returnError
        }
        return fetchAllAtDate_returnValue
    }
    
    public func fetchAll() async throws -> [ConsumptionModel] {
        if let fetchAll_returnError {
            throw fetchAll_returnError
        }
        return fetchAll_returnValue
    }
}


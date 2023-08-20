//
//  ContainerManagerStub.swift
//
//
//  Created by Petter vang Brakalsvålet on 20/08/2023.
//

import DatabaseServiceInterface

public protocol ContainerManagerStubbing {
    var createEntry_returnValue: ContainerModel { get set }
    var createEntry_returnError: Error? { get set }
    
    var update_returnValue: ContainerModel { get set }
    var update_returnError: Error? { get set }
    
    var fetchAllAtDate_returnValue: [ContainerModel] { get set }
    var fetchAllAtDate_returnError: Error? { get set }
    var fetchAll_returnValue: [ContainerModel] { get set }
    var fetchAll_returnError: Error? { get set }
}

public final class ContainerManagerStub: ContainerManagerStubbing {
    public init() {}
    
    public var createEntry_returnValue: ContainerModel = .default
    public var createEntry_returnError: Error?
    public var update_returnValue: ContainerModel = .default
    public var update_returnError: Error?
    public var fetchAllAtDate_returnValue: [ContainerModel] = .default
    public var fetchAllAtDate_returnError: Error?
    public var fetchAll_returnValue: [ContainerModel] = .default
    public var fetchAll_returnError: Error?
}

extension ContainerManagerStub: ContainerManagerType {
    public func createEntry(of size: Int) async throws -> ContainerModel {
        if let createEntry_returnError {
            throw createEntry_returnError
        }
        return createEntry_returnValue
    }
    
    public func update(_ entry: ContainerModel, newSize: Int) async throws -> ContainerModel {
        if let update_returnError {
            throw update_returnError
        }
        return update_returnValue
    }
    
    public func delete(_ entry: Entry) async throws {}
    
    public func fetchAll() async throws -> [ContainerModel] {
        if let fetchAll_returnError {
            throw fetchAll_returnError
        }
        return fetchAll_returnValue
    }
}


//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import DatabaseServiceInterface

public protocol DrinkManagerStubbing {
    var createNewDrink_returnValue: DrinkModel? { get set }
    var createNewDrink_returnError: Error? { get set }
    var edit_returnValue: Result<DrinkModel, Error> { get set }
    var delete_returnError: Error? { get set }
    var deleteDrink_returnError: Error? { get set }
    var deleteAll_returnError: Error? { get set }
    var fetch_returnValue: Result<DrinkModel, Error> { get set }
    var fetchAll_returnValue: Result<[DrinkModel], Error> { get set }
}

public final class DrinkManagerStub: DrinkManagerStubbing {
    public init() {}
    
    public var createNewDrink_returnValue: DrinkModel? = nil
    public var createNewDrink_returnError: Error? = nil
    public var edit_returnValue: Result<DrinkModel, Error> = .success(.init(id: "", size: 300, container: "small"))
    public var delete_returnError: Error? = nil
    public var deleteDrink_returnError: Error? = nil
    public var deleteAll_returnError: Error? = nil
    public var fetch_returnValue: Result<DrinkModel, Error> = .success(.init(id: "", size: 300, container: "small"))
    public var fetchAll_returnValue: Result<[DrinkModel], Error> = .success([
        .init(id: "", size: 300, container: "small"),
        .init(id: "", size: 500, container: "medium"),
        .init(id: "", size: 750, container: "large")
    ])
}

extension DrinkManagerStub: DrinkManagerType {
    public func createNewDrink(size: Double, container: String) async throws -> DrinkModel {
        if let createNewDrink_returnError {
            throw createNewDrink_returnError
        }
        if let createNewDrink_returnValue {
            return createNewDrink_returnValue
        } else {
            return .init(id: "", size: size, container: container)
        }
    }
    
    public func edit(size: Double, of container: String) async throws -> DrinkModel {
        switch edit_returnValue {
        case let .success(drink):
            return drink
        case let .failure(error):
            throw error
        }
    }
    
    public func delete(_ drink: DrinkModel) async throws {
        if let delete_returnError {
            throw delete_returnError
        }
    }
    
    public func deleteDrink(container: String) async throws {
        if let deleteDrink_returnError {
            throw deleteDrink_returnError
        }
    }
    
    public func deleteAll() async throws {
        if let deleteAll_returnError {
            throw deleteAll_returnError
        }
    }
    
    public func fetch(_ container: String) async throws -> DrinkModel {
        switch fetch_returnValue {
        case let .success(drink):
            return drink
        case let .failure(error):
            throw error
        }
    }
    
    public func fetchAll() async throws -> [DrinkModel] {
        switch fetchAll_returnValue {
        case let .success(drinks):
            return drinks
        case let .failure(error):
            throw error
        }
    }
}

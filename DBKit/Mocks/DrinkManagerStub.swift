//
//  DrinkManagerStub.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

import Foundation
import CoreData
import DBKitInterface

public protocol DrinkManagerStubbing {
    func set(_ response: DrinkManagerStub.StubResponse) async
}

public final actor DrinkManagerStub: DrinkManagerStubbing {
    public enum StubResponse: Sendable {
        case createNewDrink(Result<DrinkModel, Error>)
        case edit(Result<DrinkModel, Error>)
        case delete(Error?)
        case deleteDrink(Error?)
        case deleteAll(Error?)
        case fetch(Result<DrinkModel, Error>)
        case fetchAll(Result<[DrinkModel], Error>)
    }
    
    public init() {}
    
    private var createNewDrink_returnValue: Result<DrinkModel, Error> = .default
    private var edit_returnValue: Result<DrinkModel, Error> = .default
    private var delete_returnError: Error? = nil
    private var deleteDrink_returnError: Error? = nil
    private var deleteAll_returnError: Error? = nil
    private var fetch_returnValue: Result<DrinkModel, Error> = .default
    private var fetchAll_returnValue: Result<[DrinkModel], Error> = .default

    public func set(_ response: StubResponse) async {
        switch response {
        case .createNewDrink(let result):
            self.createNewDrink_returnValue = result
        case .edit(let result):
            self.edit_returnValue = result
        case .delete(let error):
            self.delete_returnError = error
        case .deleteDrink(let error):
            self.deleteDrink_returnError = error
        case .deleteAll(let error):
            self.deleteAll_returnError = error
        case .fetch(let result):
            self.fetch_returnValue = result
        case .fetchAll(let result):
            self.fetchAll_returnValue = result
        }
    }
}

extension DrinkManagerStub: DrinkManagerType {
    public func createNewDrink(size: Double, container: String) throws -> DrinkModel {
        switch createNewDrink_returnValue {
        case let .success(drink):
            return drink
        case let .failure(error):
            throw error
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

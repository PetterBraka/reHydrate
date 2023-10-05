//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import DrinkServiceInterface
import Foundation

public protocol DrinkServiceStubbing {
    var addDrink_returnValue: Result<Drink, DrinkDBError> { get set }
    var editDrink_returnValue: Result<Drink, DrinkDBError> { get set }
    var removeDrink_returnValue: Result<Void, DrinkDBError> { get set }
    var getSavedDrink_returnValue: Result<[Drink], DrinkDBError> { get set }
    var resetToDefault_returnValue: [Drink] { get set }
}

public final class DrinkServiceStub: DrinkServiceStubbing {
    public init() {}
    
    public var addDrink_returnValue: Result<Drink, DrinkDBError> = .default
    public var editDrink_returnValue: Result<Drink, DrinkDBError> = .default
    public var removeDrink_returnValue: Result<Void, DrinkDBError> = .default
    public var getSavedDrink_returnValue: Result<[Drink], DrinkDBError> = .default
    public var resetToDefault_returnValue: [Drink] = .default
}

extension DrinkServiceStub: DrinkServiceType {
    public func addDrink(size: Double, container: Container) throws -> Drink {
        switch addDrink_returnValue {
        case let .success(drink):
            return drink
        case let .failure(error):
            throw error
        }
    }
    
    public func editDrink(oldDrink: Drink, newDrink: Drink) throws -> Drink {
        switch editDrink_returnValue {
        case let .success(drink):
            return drink
        case let .failure(error):
            throw error
        }
    }
    
    public func remove(_ drink: Drink) async throws {
        if case .failure(let error) = removeDrink_returnValue {
            throw error
        }
    }
    
    public func getSavedDrinks() throws -> [Drink] {
        switch getSavedDrink_returnValue  {
        case let .success(drink):
            return drink
        case let .failure(error):
            throw error
        }
    }
    
    public func resetToDefault() -> [Drink] {
        resetToDefault_returnValue
    }
}

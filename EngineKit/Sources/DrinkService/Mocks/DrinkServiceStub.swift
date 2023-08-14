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
    public func addDrink(size: Double, container: Container) -> Result<Drink, DrinkDBError> {
        addDrink_returnValue
    }
    
    public func editDrink(editedDrink newDrink: Drink) -> Result<Drink, DrinkDBError> {
        editDrink_returnValue
    }
    
    public func removeDrink(withId id: UUID) -> Result<Void, DrinkDBError> {
        removeDrink_returnValue
    }
    
    public func getSavedDrinks() -> Result<[Drink], DrinkDBError> {
        getSavedDrink_returnValue
    }
    
    public func resetToDefault() -> [Drink] {
        resetToDefault_returnValue
    }
    
    
}

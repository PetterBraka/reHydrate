//
//  DayServiceStub.swift
//
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import DayServiceInterface
import DrinkServiceInterface

public protocol DayServiceStubbing {
    var getToday_returnValue: Day { get set }
    var getToday_returnError: Error? { get set }
    var addDrink_returnValue: Double { get set }
    var addDrink_returnError: Error? { get set }
    var removeDrink_returnValue: Double { get set }
    var removeDrink_returnError: Error? { get set }
}

public final class DayServiceStub: DayServiceStubbing {
    public init() {}
    
    public var getToday_returnValue: Day = .default
    public var getToday_returnError: Error?
    public var addDrink_returnValue: Double = .default
    public var addDrink_returnError: Error?
    public var removeDrink_returnValue: Double = .default
    public var removeDrink_returnError: Error?
}

extension DayServiceStub: DayServiceType {
    public func getToday() async throws -> Day {
        if let getToday_returnError {
            throw getToday_returnError
        }
        return getToday_returnValue
    }
    
    public func add(drink: Drink) async throws -> Double {
        if let addDrink_returnError {
            throw addDrink_returnError
        }
        return addDrink_returnValue
    }
    
    public func remove(drink: Drink) async throws -> Double {
        if let removeDrink_returnError {
            throw removeDrink_returnError
        }
        return removeDrink_returnValue
    }
}

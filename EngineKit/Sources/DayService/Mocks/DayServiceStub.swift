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
    
    var addDrink_returnValue: Double { get set }
    var removeDrink_returnValue: Double { get set }
}

public final class DayServiceStub: DayServiceStubbing {
    public init() {}
    
    public var getToday_returnValue: Day = .default
    public var addDrink_returnValue: Double = .default
    public var removeDrink_returnValue: Double = .default
}

extension DayServiceStub: DayServiceType {
    public func getToday() async -> Day {
        getToday_returnValue
    }
    
    public func add(drink: Drink) -> Double {
        addDrink_returnValue
    }
    
    public func remove(drink: Drink) -> Double {
        removeDrink_returnValue
    }
}

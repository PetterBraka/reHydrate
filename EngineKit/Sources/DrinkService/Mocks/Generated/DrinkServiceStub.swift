// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import DrinkServiceInterface

public protocol DrinkServiceTypeStubbing {
    var addSizeContainer_returnValue: Result<Drink, Error> { get set }
    var editSizeDrink_returnValue: Result<Drink, Error> { get set }
    var getSaved_returnValue: Result<[Drink], Error> { get set }
    var resetToDefault_returnValue: [Drink] { get set }
}

public final class DrinkServiceTypeStub: DrinkServiceTypeStubbing {
    public var addSizeContainer_returnValue: Result<Drink, Error> = .default
    public var editSizeDrink_returnValue: Result<Drink, Error> = .default
    public var getSaved_returnValue: Result<[Drink], Error> = .default
    public var resetToDefault_returnValue: [Drink] = .default

    public init() {}
}

extension DrinkServiceTypeStub: DrinkServiceType {
    public func add(size: Double, container: Container) throws -> Drink {
        switch addSizeContainer_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func edit(size: Double, of drink: Drink) throws -> Drink {
        switch editSizeDrink_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func remove(container: String) throws -> Void {
    }

    public func getSaved() throws -> [Drink] {
        switch getSaved_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func resetToDefault() -> [Drink] {
        resetToDefault_returnValue
    }

}


// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import DrinkServiceInterface

public protocol DrinkServiceTypeStubbing {
    var addSizeContainer_returnValue: Result<Drink, Error> { get set }
    var editSizeDrink_returnValue: Result<Drink, Error> { get set }
    var removeContainer_returnValue: Error? { get set }
    var getSaved_returnValue: Result<[Drink], Error> { get set }
    var resetToDefault_returnValue: [Drink] { get set }
}

public final class DrinkServiceTypeStub: DrinkServiceTypeStubbing {
    public var addSizeContainer_returnValue: Result<Drink, Error> {
        get {
            if addSizeContainer_returnValues.count > 1 {
                addSizeContainer_returnValues.removeFirst()
            } else {
                addSizeContainer_returnValues.first ?? .default
            }
        }
        set {
            addSizeContainer_returnValues.append(newValue)
        }
    }
    private var addSizeContainer_returnValues: [Result<Drink, Error>] = []
    public var editSizeDrink_returnValue: Result<Drink, Error> {
        get {
            if editSizeDrink_returnValues.count > 1 {
                editSizeDrink_returnValues.removeFirst()
            } else {
                editSizeDrink_returnValues.first ?? .default
            }
        }
        set {
            editSizeDrink_returnValues.append(newValue)
        }
    }
    private var editSizeDrink_returnValues: [Result<Drink, Error>] = []
    public var removeContainer_returnValue: Error? {
        get {
            if removeContainer_returnValues.count > 1 {
                removeContainer_returnValues.removeFirst()
            } else {
                removeContainer_returnValues.first ?? nil
            }
        }
        set {
            removeContainer_returnValues.append(newValue)
        }
    }
    private var removeContainer_returnValues: [Error?] = []
    public var getSaved_returnValue: Result<[Drink], Error> {
        get {
            if getSaved_returnValues.count > 1 {
                getSaved_returnValues.removeFirst()
            } else {
                getSaved_returnValues.first ?? .default
            }
        }
        set {
            getSaved_returnValues.append(newValue)
        }
    }
    private var getSaved_returnValues: [Result<[Drink], Error>] = []
    public var resetToDefault_returnValue: [Drink] {
        get {
            if resetToDefault_returnValues.count > 1 {
                resetToDefault_returnValues.removeFirst()
            } else {
                resetToDefault_returnValues.first ?? .default
            }
        }
        set {
            resetToDefault_returnValues.append(newValue)
        }
    }
    private var resetToDefault_returnValues: [[Drink]] = []

    public init() {}
}

extension DrinkServiceTypeStub: DrinkServiceType {
    public func add(size: Double, container: Container) async throws -> Drink {
        switch addSizeContainer_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func edit(size: Double, of drink: Drink) async throws -> Drink {
        switch editSizeDrink_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func remove(container: String) async throws -> Void {
        if let removeContainer_returnValue {
            throw removeContainer_returnValue
        }
    }

    public func getSaved() async throws -> [Drink] {
        switch getSaved_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func resetToDefault() async -> [Drink] {
        resetToDefault_returnValue
    }

}

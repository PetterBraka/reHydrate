// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import DrinkServiceInterface

public protocol DrinkServiceTypeSpying {
    var variableLog: [DrinkServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: DrinkServiceTypeSpy.VariableName? { get }
    var methodLog: [DrinkServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: DrinkServiceTypeSpy.MethodCall? { get }
    var methodNameLog: [DrinkServiceTypeSpy.MethodName] { get set }
}

public final class DrinkServiceTypeSpy: DrinkServiceTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case addSizeContainer(size: Double, container: Container)
        case editSizeDrink(size: Double, drink: Container)
        case removeContainer(container: Container)
        case getSaved
        case resetToDefault
    }

    public enum MethodName {
        case addSizeContainer
        case editSizeDrink
        case removeContainer
        case getSaved
        case resetToDefault
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: DrinkServiceType
    public init(realObject: DrinkServiceType) {
        self.realObject = realObject
    }
}

extension DrinkServiceTypeSpy: DrinkServiceType {
    public func add(size: Double, container: Container) async throws -> Drink {
        methodNameLog.append(.addSizeContainer)
        methodLog.append(.addSizeContainer(size: size, container: container))
        return try await realObject.add(size: size, container: container)
    }
    public func edit(size: Double, of drink: Container) async throws -> Drink {
        methodNameLog.append(.editSizeDrink)
        methodLog.append(.editSizeDrink(size: size, drink: drink))
        return try await realObject.edit(size: size, of: drink)
    }
    public func remove(container: Container) async throws -> Void {
        methodNameLog.append(.removeContainer)
        methodLog.append(.removeContainer(container: container))
        try await realObject.remove(container: container)
    }
    public func getSaved() async throws -> [Drink] {
        methodNameLog.append(.getSaved)
        methodLog.append(.getSaved)
        return try await realObject.getSaved()
    }
    public func resetToDefault() async -> [Drink] {
        methodNameLog.append(.resetToDefault)
        methodLog.append(.resetToDefault)
        return await realObject.resetToDefault()
    }
}

extension DrinkServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension DrinkServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .addSizeContainer(let size, let container): "add(size: \(String(describing: size)), container: \(String(describing: container)))"
        case .editSizeDrink(let size, let drink): "edit(size: \(String(describing: size)), drink: \(String(describing: drink)))"
        case .removeContainer(let container): "remove(container: \(String(describing: container)))"
        case .getSaved: "getSaved"
        case .resetToDefault: "resetToDefault"
        }
    }
}

extension DrinkServiceTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .addSizeContainer: "addSizeContainer"
        case .editSizeDrink: "editSizeDrink"
        case .removeContainer: "removeContainer"
        case .getSaved: "getSaved"
        case .resetToDefault: "resetToDefault"
        }
    }
}

// MARK: - AutoString
// swiftlint:disable all

import DrinkServiceInterface

extension Drink: CustomStringConvertible {
    public var description: String {
        "Drink(id: \(String(describing: id)) container: \(String(describing: container)) size: \(String(describing: size)) )"
    }
}

extension Container: CustomStringConvertible {
    public var description: String {
        switch self {
        case .small: "small"
        case .medium: "medium"
        case .large: "large"
        case .health: "health"
        }
    }
}


// MARK: - AutoStub
// swiftlint:disable all  
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
            if addSizeContainer_returnValues.isEmpty {
                .default
            } else {
                addSizeContainer_returnValues.removeFirst()
            }
        }
        set {
            addSizeContainer_returnValues.append(newValue)
        }
    }
    private var addSizeContainer_returnValues: [Result<Drink, Error>] = []
    public var editSizeDrink_returnValue: Result<Drink, Error> {
        get {
            if editSizeDrink_returnValues.isEmpty {
                .default
            } else {
                editSizeDrink_returnValues.removeFirst()
            }
        }
        set {
            editSizeDrink_returnValues.append(newValue)
        }
    }
    private var editSizeDrink_returnValues: [Result<Drink, Error>] = []
    public var removeContainer_returnValue: Error? {
        get {
            if removeContainer_returnValues.isEmpty {
                nil
            } else {
                removeContainer_returnValues.removeFirst()
            }
        }
        set {
            removeContainer_returnValues.append(newValue)
        }
    }
    private var removeContainer_returnValues: [Error?] = []
    public var getSaved_returnValue: Result<[Drink], Error> {
        get {
            if getSaved_returnValues.isEmpty {
                .default
            } else {
                getSaved_returnValues.removeFirst()
            }
        }
        set {
            getSaved_returnValues.append(newValue)
        }
    }
    private var getSaved_returnValues: [Result<[Drink], Error>] = []
    public var resetToDefault_returnValue: [Drink] {
        get {
            if resetToDefault_returnValues.isEmpty {
                .default
            } else {
                resetToDefault_returnValues.removeFirst()
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

    public func edit(size: Double, of drink: Container) async throws -> Drink {
        switch editSizeDrink_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func remove(container: Container) async throws -> Void {
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

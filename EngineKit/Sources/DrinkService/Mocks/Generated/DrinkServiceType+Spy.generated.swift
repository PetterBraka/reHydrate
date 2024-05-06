// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import DrinkServiceInterface

public protocol DrinkServiceTypeSpying {
    var variableLog: [DrinkServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: DrinkServiceTypeSpy.VariableName? { get }
    var methodLog: [DrinkServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: DrinkServiceTypeSpy.MethodCall? { get }
}

public final class DrinkServiceTypeSpy: DrinkServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case add(size: Double, container: Container)
        case edit(size: Double, drink: Drink)
        case remove(container: String)
        case getSaved
        case resetToDefault
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: DrinkServiceType
    public init(realObject: DrinkServiceType) {
        self.realObject = realObject
    }
}

extension DrinkServiceTypeSpy: DrinkServiceType {
    public func add(size: Double, container: Container) async throws -> Drink {
        methodLog.append(.add(size: size, container: container))
        return try await realObject.add(size: size, container: container)
    }
    public func edit(size: Double, of drink: Drink) async throws -> Drink {
        methodLog.append(.edit(size: size, drink: drink))
        return try await realObject.edit(size: size, of: drink)
    }
    public func remove(container: String) async throws -> Void {
        methodLog.append(.remove(container: container))
        try await realObject.remove(container: container)
    }
    public func getSaved() async throws -> [Drink] {
        methodLog.append(.getSaved)
        return try await realObject.getSaved()
    }
    public func resetToDefault() async -> [Drink] {
        methodLog.append(.resetToDefault)
        return await realObject.resetToDefault()
    }
}

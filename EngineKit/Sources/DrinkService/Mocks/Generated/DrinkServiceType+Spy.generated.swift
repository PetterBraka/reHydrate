// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import DrinkServiceInterface

public protocol DrinkServiceTypeSpying {
    var variableLog: [DrinkServiceTypeSpy.VariableName] { get set }
    var methodLog: [DrinkServiceTypeSpy.MethodName] { get set }
}

public final class DrinkServiceTypeSpy: DrinkServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
        case add_size_container
        case edit_size_of
        case remove_container
        case getSaved
        case resetToDefault
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: DrinkServiceType
    public init(realObject: DrinkServiceType) {
        self.realObject = realObject
    }
}

extension DrinkServiceTypeSpy: DrinkServiceType {
    public func add(size: Double, container: Container) async throws -> Drink {
        methodLog.append(.add_size_container)
        return try await realObject.add(size: size, container: container)
    }
    public func edit(size: Double, of drink: Drink) async throws -> Drink {
        methodLog.append(.edit_size_of)
        return try await realObject.edit(size: size, of: drink)
    }
    public func remove(container: String) async throws -> Void {
        methodLog.append(.remove_container)
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

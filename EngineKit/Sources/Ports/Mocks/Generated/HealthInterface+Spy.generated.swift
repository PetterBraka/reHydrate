// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol HealthInterfaceSpying {
    var variableLog: [HealthInterfaceSpy.VariableName] { get set }
    var lastVariabelCall: HealthInterfaceSpy.VariableName? { get }
    var methodLog: [HealthInterfaceSpy.MethodCall] { get set }
    var lastMethodCall: HealthInterfaceSpy.MethodCall? { get }
}

public final class HealthInterfaceSpy: HealthInterfaceSpying {
    public enum VariableName {
        case isSupported
    }

    public enum MethodCall {
        case shouldRequestAccess(healthDataType: [HealthDataType])
        case canWrite(dataType: HealthDataType)
        case requestAuth(readAndWrite: Set<HealthDataType>)
        case export(quantity: Quantity, id: QuantityTypeIdentifier, date: Date)
        case readSum(data: HealthDataType, start: Date, end: Date, intervalComponents: DateComponents)
        case readSamples(data: HealthDataType, start: Date, end: Date)
        case enableBackgroundDelivery(healthData: HealthDataType, frequency: HealthFrequency)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: HealthInterface
    public init(realObject: HealthInterface) {
        self.realObject = realObject
    }
}

extension HealthInterfaceSpy: HealthInterface {
    public var isSupported: Bool {
        get {
            variableLog.append(.isSupported)
            return realObject.isSupported
        }
    }
    public func shouldRequestAccess(for healthDataType: [HealthDataType]) async -> Bool {
        methodLog.append(.shouldRequestAccess(healthDataType: healthDataType))
        return await realObject.shouldRequestAccess(for: healthDataType)
    }
    public func canWrite(_ dataType: HealthDataType) -> Bool {
        methodLog.append(.canWrite(dataType: dataType))
        return realObject.canWrite(dataType)
    }
    public func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws -> Void {
        methodLog.append(.requestAuth(readAndWrite: readAndWrite))
        try await realObject.requestAuth(toReadAndWrite: readAndWrite)
    }
    public func export(quantity: Quantity, id: QuantityTypeIdentifier, date: Date) async throws -> Void {
        methodLog.append(.export(quantity: quantity, id: id, date: date))
        try await realObject.export(quantity: quantity, id: id, date: date)
    }
    public func readSum(_ data: HealthDataType, start: Date, end: Date, intervalComponents: DateComponents) async throws -> Double {
        methodLog.append(.readSum(data: data, start: start, end: end, intervalComponents: intervalComponents))
        return try await realObject.readSum(data, start: start, end: end, intervalComponents: intervalComponents)
    }
    public func readSamples(_ data: HealthDataType, start: Date, end: Date) async throws -> [Double] {
        methodLog.append(.readSamples(data: data, start: start, end: end))
        return try await realObject.readSamples(data, start: start, end: end)
    }
    public func enableBackgroundDelivery(healthData: HealthDataType, frequency: HealthFrequency) async throws -> Void {
        methodLog.append(.enableBackgroundDelivery(healthData: healthData, frequency: frequency))
        try await realObject.enableBackgroundDelivery(healthData: healthData, frequency: frequency)
    }
}

// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol HealthInterfaceSpying {
    var variableLog: [HealthInterfaceSpy.VariableName] { get set }
    var methodLog: [HealthInterfaceSpy.MethodName] { get set }
}

public final class HealthInterfaceSpy: HealthInterfaceSpying {
    public enum VariableName {
        case isSupported
    }

    public enum MethodName {
        case shouldRequestAccess_for
        case canWrite
        case requestAuth_toReadAndWrite
        case export_quantity_id_date
        case readSum_start_end_intervalComponents
        case readSamples_start_end
        case enableBackgroundDelivery_healthData_frequency
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: HealthInterface
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
        methodLog.append(.shouldRequestAccess_for)
        return await realObject.shouldRequestAccess(for: healthDataType)
    }
    public func canWrite(_ dataType: HealthDataType) -> Bool {
        methodLog.append(.canWrite)
        return realObject.canWrite(dataType)
    }
    public func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws -> Void {
        methodLog.append(.requestAuth_toReadAndWrite)
        try await realObject.requestAuth(toReadAndWrite: readAndWrite)
    }
    public func export(quantity: Quantity, id: QuantityTypeIdentifier, date: Date) async throws -> Void {
        methodLog.append(.export_quantity_id_date)
        try await realObject.export(quantity: quantity, id: id, date: date)
    }
    public func readSum(_ data: HealthDataType, start: Date, end: Date, intervalComponents: DateComponents) async throws -> Double {
        methodLog.append(.readSum_start_end_intervalComponents)
        return try await realObject.readSum(data, start: start, end: end, intervalComponents: intervalComponents)
    }
    public func readSamples(_ data: HealthDataType, start: Date, end: Date) async throws -> [Double] {
        methodLog.append(.readSamples_start_end)
        return try await realObject.readSamples(data, start: start, end: end)
    }
    public func enableBackgroundDelivery(healthData: HealthDataType, frequency: HealthFrequency) async throws -> Void {
        methodLog.append(.enableBackgroundDelivery_healthData_frequency)
        try await realObject.enableBackgroundDelivery(healthData: healthData, frequency: frequency)
    }
}

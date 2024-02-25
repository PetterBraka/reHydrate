// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import PortsInterface

public protocol HealthInterfaceStubbing {
    var isSupported_returnValue: Bool { get set }
    var shouldRequestAccessHealthDataType_returnValue: Bool { get set }
    var canWriteDataType_returnValue: Bool { get set }
    var requestAuthReadAndWrite_returnValue: Error? { get set }
    var exportQuantityIdDate_returnValue: Error? { get set }
    var enableBackgroundDeliveryHealthDataFrequency_returnValue: Error? { get set }
}

public final class HealthInterfaceStub: HealthInterfaceStubbing {
    public var isSupported_returnValue: Bool = .default
    public var shouldRequestAccessHealthDataType_returnValue: Bool = .default
    public var canWriteDataType_returnValue: Bool = .default
    public var requestAuthReadAndWrite_returnValue: Error? = nil
    public var exportQuantityIdDate_returnValue: Error? = nil
    public var enableBackgroundDeliveryHealthDataFrequency_returnValue: Error? = nil

    public init() {}
}

extension HealthInterfaceStub: HealthInterface {
    public var isSupported: Bool { isSupported_returnValue }
    public func shouldRequestAccess(for healthDataType: [HealthDataType]) async -> Bool {
        shouldRequestAccessHealthDataType_returnValue
    }

    public func canWrite(_ dataType: HealthDataType) -> Bool {
        canWriteDataType_returnValue
    }

    public func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws -> Void {
        if let requestAuthReadAndWrite_returnValue {
            throw requestAuthReadAndWrite_returnValue
        }
    }

    public func export(quantity: Quantity, id: QuantityTypeIdentifier, date: Date) async throws -> Void {
        if let exportQuantityIdDate_returnValue {
            throw exportQuantityIdDate_returnValue
        }
    }

    public func read(_ data: HealthDataType, queryType: HealthQuery) -> Void {
    }

    public func enableBackgroundDelivery(healthData: HealthDataType, frequency: HealthFrequency) async throws -> Void {
        if let enableBackgroundDeliveryHealthDataFrequency_returnValue {
            throw enableBackgroundDeliveryHealthDataFrequency_returnValue
        }
    }

}

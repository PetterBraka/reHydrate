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
    var readSumDataStartEndIntervalComponents_returnValue: Result<Double, Error> { get set }
    var readSamplesDataStartEnd_returnValue: Result<[Double], Error> { get set }
    var enableBackgroundDeliveryHealthDataFrequency_returnValue: Error? { get set }
}

public final class HealthInterfaceStub: HealthInterfaceStubbing {
    public var isSupported_returnValue: Bool {
        get {
            if isSupported_returnValues.first != nil {
                isSupported_returnValues.removeLast()
            } else {
                .default
            }
        }
        set {
            isSupported_returnValues.append(newValue)
        }
    }
    private var isSupported_returnValues: [Bool] = []
    public var shouldRequestAccessHealthDataType_returnValue: Bool {
        get {
            if shouldRequestAccessHealthDataType_returnValues.first != nil {
                shouldRequestAccessHealthDataType_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            shouldRequestAccessHealthDataType_returnValues.append(newValue)
        }
    }
    private var shouldRequestAccessHealthDataType_returnValues: [Bool] = []
    public var canWriteDataType_returnValue: Bool {
        get {
            if canWriteDataType_returnValues.first != nil {
                canWriteDataType_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            canWriteDataType_returnValues.append(newValue)
        }
    }
    private var canWriteDataType_returnValues: [Bool] = []
    public var requestAuthReadAndWrite_returnValue: Error? {
        get {
            if requestAuthReadAndWrite_returnValues.first != nil {
                requestAuthReadAndWrite_returnValues.removeFirst()
            } else {
                nil
            }
        }
        set {
            requestAuthReadAndWrite_returnValues.append(newValue)
        }
    }
    private var requestAuthReadAndWrite_returnValues: [Error?] = []
    public var exportQuantityIdDate_returnValue: Error? {
        get {
            if exportQuantityIdDate_returnValues.first != nil {
                exportQuantityIdDate_returnValues.removeFirst()
            } else {
                nil
            }
        }
        set {
            exportQuantityIdDate_returnValues.append(newValue)
        }
    }
    private var exportQuantityIdDate_returnValues: [Error?] = []
    public var readSumDataStartEndIntervalComponents_returnValue: Result<Double, Error> {
        get {
            if readSumDataStartEndIntervalComponents_returnValues.first != nil {
                readSumDataStartEndIntervalComponents_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            readSumDataStartEndIntervalComponents_returnValues.append(newValue)
        }
    }
    private var readSumDataStartEndIntervalComponents_returnValues: [Result<Double, Error>] = []
    public var readSamplesDataStartEnd_returnValue: Result<[Double], Error> {
        get {
            if readSamplesDataStartEnd_returnValues.first != nil {
                readSamplesDataStartEnd_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            readSamplesDataStartEnd_returnValues.append(newValue)
        }
    }
    private var readSamplesDataStartEnd_returnValues: [Result<[Double], Error>] = []
    public var enableBackgroundDeliveryHealthDataFrequency_returnValue: Error? {
        get {
            if enableBackgroundDeliveryHealthDataFrequency_returnValues.first != nil {
                enableBackgroundDeliveryHealthDataFrequency_returnValues.removeFirst()
            } else {
                nil
            }
        }
        set {
            enableBackgroundDeliveryHealthDataFrequency_returnValues.append(newValue)
        }
    }
    private var enableBackgroundDeliveryHealthDataFrequency_returnValues: [Error?] = []

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

    public func readSum(_ data: HealthDataType, start: Date, end: Date, intervalComponents: DateComponents) async throws -> Double {
        switch readSumDataStartEndIntervalComponents_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func readSamples(_ data: HealthDataType, start: Date, end: Date) async throws -> [Double] {
        switch readSamplesDataStartEnd_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func enableBackgroundDelivery(healthData: HealthDataType, frequency: HealthFrequency) async throws -> Void {
        if let enableBackgroundDeliveryHealthDataFrequency_returnValue {
            throw enableBackgroundDeliveryHealthDataFrequency_returnValue
        }
    }

}

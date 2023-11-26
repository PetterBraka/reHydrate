//
//  HealthServiceStub.swift
//
//
//  Created by Petter vang Brakalsvålet on 26/11/2023.
//

import Foundation
import PortsInterface

public protocol HealthServiceStubbing {
    var isSupported_returnValue: Bool { get set }
    var shouldRequestAccess_returnValue: Bool { get set }
    var canWrite_returnValue: Bool { get set }
    var requestAuth_returnValue: Error? { get set }
    var export_returnValue: Error? { get set }
    var enableBackgroundDelivery_returnValue: Error? { get set }
}

public final class HealthServiceStub: HealthServiceStubbing {
    public init() {}
    
    public var isSupported_returnValue: Bool = true
    public var shouldRequestAccess_returnValue: Bool = true
    public var canWrite_returnValue: Bool = true
    public var requestAuth_returnValue: Error?
    public var export_returnValue: Error?
    public var enableBackgroundDelivery_returnValue: Error?
}

extension HealthServiceStub: HealthInterface {
    public var isSupported: Bool {
        isSupported_returnValue
    }
    
    public func shouldRequestAccess(for healthDataType: [PortsInterface.HealthDataType]) async -> Bool {
        shouldRequestAccess_returnValue
    }
    
    public func canWrite(_ dataType: PortsInterface.HealthDataType) -> Bool {
        canWrite_returnValue
    }
    
    public func requestAuth(toReadAndWrite readAndWrite: Set<PortsInterface.HealthDataType>) async throws {
        if let requestAuth_returnValue {
            throw requestAuth_returnValue
        }
    }
    
    public func export(quantity: PortsInterface.Quantity, id: PortsInterface.QuantityTypeIdentifier, date: Date) async throws {
        if let export_returnValue {
            throw export_returnValue
        }
    }
    
    public func enableBackgroundDelivery(healthData: PortsInterface.HealthDataType, frequency: PortsInterface.HealthFrequency) async throws {
        if let enableBackgroundDelivery_returnValue {
            throw enableBackgroundDelivery_returnValue
        }
    }
    
}

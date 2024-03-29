//
//  HealthInterface.swift
//
//
//  Created by Petter vang Brakalsvålet on 25/11/2023.
//

import Foundation

public protocol HealthInterface {
    var isSupported: Bool { get }
    
    func shouldRequestAccess(for healthDataType: [HealthDataType]) async -> Bool
    func canWrite(_ dataType: HealthDataType) -> Bool
    func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws
    
    func export(quantity: Quantity, 
                id: QuantityTypeIdentifier,
                date: Date) async throws
    func readSum(_ data: HealthDataType, start: Date, end: Date, intervalComponents: DateComponents) async throws -> Double
    func readSamples(_ data: HealthDataType, start: Date, end: Date) async throws -> [Double]
    
    func enableBackgroundDelivery(healthData: HealthDataType,
                                  frequency: HealthFrequency) async throws
}
